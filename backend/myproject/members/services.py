import os
from django.contrib.auth import authenticate, logout, login
from django.core.management import call_command
from django.shortcuts import get_object_or_404
from django.http import JsonResponse
from django.middleware.csrf import get_token
from django.core.files.base import ContentFile
from django.core.files.storage import default_storage
from .models import CustomUser as User

class UserAuthService:
    def login_user(self, request, email, password):
        user = authenticate(request, username=email, password=password)
        if user is not None:
            login(request, user)
            return {
                "message": "Login successful",
                "role": user.role,
                "csrf_token": get_token(request)
            }
        return None  # caller can then return an error response

    def logout_user(self, request):
        logout(request)
        return {"message": "Logged out successfully"}

    def get_user_profile(self, request):
        if request.user.is_authenticated:
            return {
                "username": request.user.username,
                "email": request.user.email,
                "github": request.user.github,
                "first_name": request.user.first_name,
            }
        return None

    def edit_user_profile(self, request, payload):
        if not request.user.is_authenticated:
            return None
        user = get_object_or_404(User, srn=request.user.srn)
        for attr, value in payload.dict().items():
            setattr(user, attr, value)
        user.save()
        return user

    def import_users_from_file(self, file):
        file_path = default_storage.save(f"temp/{file.name}", ContentFile(file.read()))
        try:
            call_command("import_users", default_storage.path(file_path))
        except Exception as e:
            return {"error": str(e)}
        finally:
            full_path = default_storage.path(file_path)
            if os.path.exists(full_path):
                os.remove(full_path)
        return {"message": "User import initiated successfully!"}
