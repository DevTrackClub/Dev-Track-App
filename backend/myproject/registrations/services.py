from django.shortcuts import get_object_or_404
from projects.models import DomainModel, ProjectCycleModel
from .models import ProjectApplicationModel
from ninja.errors import HttpError, AuthenticationError
from ninja.security import HttpBearer
from django.utils import timezone


class ProjectApplicationService:
    def enroll_user(self, request, payload):
        # Check if user is authenticated
        if not request.user.is_authenticated:
            raise HttpError(400, "Authentication required")

        user = request.user

        # Retrieve the current active project cycle
        cycle = ProjectCycleModel.objects.filter(is_active=True).first()
        if not cycle:
            raise HttpError(400, "No active project cycle found.")
        
        current_time = timezone.now()
        if not (cycle.application_start_time <= current_time <= cycle.application_end_time):
            raise HttpError(400, "Applications are closed for this cycle.")
        
        if payload.first_preference_id == payload.second_preference_id:
            raise HttpError(400, "First and second preference cannot be the same.")

        # Retrieve the domain choices
        #Instructions for frontend : 
            # Send the domain id in the payload,
            # But in the ui, show the domain name to the user
            # This way, the user will see the domain name, but the backend will receive the domain id
        first_pref = get_object_or_404(DomainModel, id=payload.first_preference_id)
        second_pref = get_object_or_404(DomainModel, id=payload.second_preference_id)

        # Create or get the application
        application, created = ProjectApplicationModel.objects.get_or_create(
            user=user,
            cycle=cycle,
            defaults={
                "first_preference": first_pref,
                "second_preference": second_pref,
            }
        )

        if not created:
            return {"message": "You have already applied for this cycle."}

        return {"message": "Application submitted successfully, hang tight!"}
    

    def get_application_dates(self):
        # Get the active project cycle
        cycle = ProjectCycleModel.objects.filter(is_active=True).first()
        if not cycle:
            return {"message": "No active project cycle found."}

        return {
            "application_start_date": cycle.application_start_time.strftime("%Y-%m-%d %H:%M:%S"),
            "application_end_date": cycle.application_end_time.strftime("%Y-%m-%d %H:%M:%S"),
        }

    
    
class CustomSessionAuth(HttpBearer):
    def authenticate(self, request, token=None):
        print(f"Session Key: {request.session.session_key}")  # Debugging
        if request.user.is_authenticated:
            return request.user
        raise AuthenticationError("Session authentication failed")
