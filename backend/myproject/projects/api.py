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

from .services import ProjectService, DomainService
from .schemas import ListProjectSchema, CreateDomainSchema, ListDomainSchema 
from .models import ProjectModel, DomainModel


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
        

    #API call to create a new project cycle.
    @route.post("/cycle/create", url_name="Create project cycle")
    def create_project_cycle(self, request, payload:schemas.CreateProjectCycleSchema):
        return self.project_service.create_project_cycle(request, payload)


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



