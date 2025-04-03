from . import schemas
from django.shortcuts import get_object_or_404
from django.http import JsonResponse
from ninja_jwt.authentication import JWTAuth
from ninja_jwt.tokens import RefreshToken
from ninja_extra import NinjaExtraAPI, ControllerBase, api_controller, route 
from ninja_jwt.controller import NinjaJWTDefaultController
from ninja import File, Form, UploadedFile
from ninja.errors import HttpError
from datetime import datetime

from .services import ProjectCycleService, ProjectService, DomainService
from .schemas import CreateProjectCycleSchema, ListProjectSchema, CreateDomainSchema, ListDomainSchema, PCSchema, UpdateProjectCycleSchema 
from .models import ProjectCycleModel, ProjectModel, DomainModel




@api_controller("/projects", tags="Projects")
class ProjectsAPI(ControllerBase):

    def __init__(self) -> None:
        self.project_service = ProjectService()
        self.domain_service = DomainService()


    #API call to create domain.
    @route.post("/domain/create", url_name="Create domain")
    def create_domain(self, payload:schemas.CreateDomainSchema):
        response = self.domain_service.create_domain(payload)
        if 'error' in response:
            raise HttpError(400, response['error'])
        return response
    

    #API call to list the existing domains. 
    @route.get("/domains/list", url_name="List domains", response=list[ListDomainSchema])
    def list_domain(self, request):
        try: 
            domains = DomainModel.objects.all()
            domain_list = [ListDomainSchema(id=domain.id, name=domain.name) for domain in domains]
            return domain_list
        except Exception as e:
            raise HttpError(400, str(e))
        

@api_controller("/cycle", tags=["Project Cycle"])
class ProjectCycleController(ControllerBase):
    def __init__(self) -> None:
        self.cycle_service = ProjectCycleService()

    #Create a new project cycle
    @route.post("/create", url_name="Create Project Cycle")
    def create_cycle(self, request, payload: CreateProjectCycleSchema):
        admin_check = self.cycle_service._check_admin(request)
        if admin_check:
            return admin_check

        response = self.cycle_service.create_cycle(payload)  # Calls service layer
        if 'error' in response:
            raise HttpError(400, response['error'])
        return response
    #List all project cycles
    @route.get("/list", url_name="List Project Cycles", response=list[PCSchema])
    def list_cycles(self, request):
       
        admin_check = self.cycle_service._check_admin(request)
        if admin_check:
            return admin_check

        
        response = self.cycle_service.get_all_cycles()
        if 'error' in response:
            raise HttpError(400, response['error'])
        return response

    #Update a project cycle
    @route.put("/update/{cycle_id}", url_name="Update Project Cycle", response=PCSchema)
    def update_cycle(self, request, cycle_id: int, payload: UpdateProjectCycleSchema):
        admin_check = self.cycle_service._check_admin(request)
        if admin_check:
            return admin_check

        cycle = get_object_or_404(ProjectCycleModel, id=cycle_id)
        response = self.cycle_service.update_cycle(cycle, payload)
        if 'error' in response:
            raise HttpError(400, response['error'])
        return response

    #Deactivate a project cycle
    @route.delete("/deactivate/{cycle_id}", url_name="Deactivate Project Cycle")
    def deactivate_cycle(self, request, cycle_id: int):
        admin_check = self.cycle_service._check_admin(request)
        if admin_check:
            return admin_check

        
        response = self.cycle_service.deactivate_project_cycle(request, cycle_id)  
        if 'error' in response:
            raise HttpError(400, response['error'])
        return response

    # #API call to create a new project
    # @route.post("/create", url_name="Create project")
    # def create_project(self, payload:schemas.CreateProjectSchema, file: UploadedFile = File(...)):
    #     response = self.project_service.create_project(payload,file)
    #     if 'error' in response:
    #         raise HttpError(400, response['error'])
    #     return {"message": "Project created successfully", "project_id": response['project_id']}


    # #Api to list all the names of the projects. 
    # @route.get("/list", url_name="List Projects", response=list[ListProjectSchema])
    # def list_projects(self,request):
    #     try: 
    #         projects = ProjectModel.objects.all()
    #         project_list = [
    #             ListProjectSchema(
    #                 name=project.name,
    #                 domain=project.domain.name,
    #                 created_at=project.created_at.isoformat()
    #             )
    #             for project in projects
    #         ]
    #         return project_list
    #     except Exception as e:
    #         raise HttpError(400, str(e))



