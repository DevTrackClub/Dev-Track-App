from django.http import JsonResponse
from ninja_extra import NinjaExtraAPI, ControllerBase, api_controller, route
from ninja import UploadedFile
from django.shortcuts import get_object_or_404
from django.middleware.csrf import get_token

from . import schemas
from .models import CustomUser as User
from .services import UserAuthService
from projects.api import ProjectsAPI
from announcements.api import PostAPIController
from registrations.api import ProjectApplicationAPI 

@api_controller("/user", tags="User Authentication")
class UserAuthAPI(ControllerBase):
    def __init__(self) -> None:
        self.auth_service = UserAuthService()

    # API call for user to login by giving username and password.
    @route.post("/login", url_name="User login", auth=None, response=schemas.LoginResponseSchema)
    def login_view(self, request, data: schemas.SignInSchema):
        result = self.auth_service.login_user(request, data.email, data.password)
        if result:
            return result
        return JsonResponse({"detail": "Invalid credentials"}, status=401)

    # API call made by a user to logout.
    @route.post("/logout")
    def logout_view(self, request):
        return self.auth_service.logout_user(request)

    # API call made by user to view their profile.
    @route.get("/user", response=schemas.UserProfileResponseSchema)
    def user_profile(self, request):
        result = self.auth_service.get_user_profile(request)
        if result:
            return result
        return JsonResponse({"detail": "Not logged in"}, status=401)

    # API call made by user to edit their profile.
    @route.put("/edit", response=schemas.RegisterSchema)
    def edit_profile(self, request, payload: schemas.RegisterSchema):
        if not request.user.is_authenticated:
            return JsonResponse({"detail": "Authentication required"}, status=401)
        user = self.auth_service.edit_user_profile(request, payload)
        return user

    # API call to import users using the management command.
    @route.post("/import-users/", url_name="Import Users")
    def import_users(self, request, file: UploadedFile):
        return self.auth_service.import_users_from_file(file)

# Register controllers with the NinjaExtraAPI instance.
api = NinjaExtraAPI(csrf=False)
api.register_controllers(UserAuthAPI)
api.register_controllers(PostAPIController)
api.register_controllers(ProjectsAPI)
api.register_controllers(ProjectApplicationAPI)
