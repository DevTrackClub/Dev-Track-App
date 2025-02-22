import os
from django.contrib.auth import authenticate, logout, login
from .models import CustomUser as User
from django.core.management import call_command
from . import schemas
from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from ninja_extra import NinjaExtraAPI, ControllerBase, api_controller, route 
from django.middleware.csrf import get_token
from ninja import UploadedFile
from django.core.files.base import ContentFile
from django.core.files.storage import default_storage



from projects.api import ProjectsAPI
from announcements.api import PostAPIController 



@api_controller("/user", tags="User Authentication")
class UserAuthAPI(ControllerBase):

    #API call for user to login by giving username and password.
    @route.post("/login", url_name="User login", auth=None)
    def login_view(self, request, payload: schemas.SignInSchema, response=schemas.LoginResponseSchema):
        user = authenticate(request, username=payload.email, password=payload.password)
        if user is not None:
            login(request, user)  
            return {
                "message": "Login successful",
                "role": user.role,
                "csrf_token": get_token(request)  # Provide CSRF token for frontend
            }
        return JsonResponse({"detail": "Invalid credentials"}, status=401)


    #API call made by a user to logout.
    @route.post("/logout")
    def logout_view(self, request):
        logout(request)
        return {"message": "Logged out successfully"}


    #API call made by user to view their profile. 
    @route.get("/user")
    def user_profile(self, request, response=schemas.UserProfileResponseSchema):
        if request.user.is_authenticated:
            return {
                "username": request.user.username,
                "email": request.user.email,
                "github": request.user.github,
                "fname" : request.user.fname,
            }
        return JsonResponse({"detail": "Not logged in"}, status=401)


    @route.put("/edit",response=schemas.RegisterSchema)
    def edit_profile(self, request, payload : schemas.RegisterSchema):
        if not request.user.is_authenticated:
            return JsonResponse({"detail": "Authentication required"}, status=401)

        user = get_object_or_404(User, srn=request.user.srn)
        for attr, value in payload.dict().items():
            setattr(user, attr, value)
        user.save()
        return user
    

    @route.post("/import-users/", url_name="Import Users")
    def import_users(self, request, file: UploadedFile):
        """API endpoint to import users using the management command"""
        file_path = default_storage.save(f"temp/{file.name}", ContentFile(file.read()))
    
        try:
            # Call the management command
            call_command("import_users", default_storage.path(file_path))
        except Exception as e:
            return {"error": str(e)}
        finally:
            # Ensure file deletion after processing
            if os.path.exists(default_storage.path(file_path)):
                os.remove(default_storage.path(file_path))
    
        return {"message": "User import initiated successfully!"}




api = NinjaExtraAPI(csrf=False)
api.register_controllers(UserAuthAPI)
api.register_controllers(PostAPIController)
api.register_controllers(ProjectsAPI)



















    
    

