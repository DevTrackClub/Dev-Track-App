from ninja import Router
from ninja_extra import ControllerBase, api_controller, route
from .schemas import ProjectApplicationSchema
from .services import ProjectApplicationService

@api_controller("/applications", tags=["Project Applications"])
class ProjectApplicationAPI(ControllerBase):

    def __init__(self) -> None:
        self.application_service = ProjectApplicationService()

    @route.post("/enroll", url_name="Enroll in Project")
    def enroll_now(self, request, payload: ProjectApplicationSchema):
        response = self.application_service.enroll_user(request, payload)
        return response
