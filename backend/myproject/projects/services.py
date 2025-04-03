from django.core.files.storage import default_storage

from django.shortcuts import get_object_or_404
from .models import ProjectModel
from .schemas import CreateProjectSchema, ListProjectSchema, CreateDomainSchema, ListDomainSchema, PCSchema, UpdateProjectCycleSchema
from members.models import FileModel
from projects.models import DomainModel, ProjectCycleModel
from projects.schemas import CreateProjectCycleSchema, CreateDomainSchema
from ninja.errors import HttpError


class ProjectService:   

    def create_project(self, details : CreateProjectSchema, pdf_file):
        try:
            try:
                domain = DomainModel.objects.get(id=details.domain_id)
            except DomainModel.DoesNotExist:
                return {"error": "Domain not found"}
            
            new_project = ProjectModel(
                name = details.name, 
                github_link = details.github_link,
                youtube_link = details.youtube_link, 
                domain = domain,
            )
            new_project.save()

            if pdf_file:
                file_path = default_storage.save(f'projects/{pdf_file.name}', pdf_file)
                file_instance = FileModel.objects.create(
                    name = pdf_file.name,
                    type = FileModel.PDF,
                    file = file_path,
                    related_project = new_project
                )  
                new_project.pdf_report = file_instance
                new_project.save()

            return {"message": "Project created successfully", "data": {"project_id": new_project.id}}

        except Exception as e:
                return {"error": str(e)}
        

    def create_project_cycle(self, payload : CreateProjectCycleSchema):
        try:
            response = ProjectCycleModel.objects.create(
                cycle_name = payload.cycle_name,
                start_date = payload.start_date,    #Notes for frontend : Dates will be in the format :
                end_date = payload.end_date,        #ISO 8601 format : YYYY-MM-DD 
                is_active = payload.is_active
            )
            return {"Success":"Project cycle has been created"}
        except Exception as e:
            return {"error": str(e)}
        

class DomainService:
     
    #Service to create a new domain
    def create_domain(self,payload : CreateDomainSchema):
        try:
            response =  DomainModel.objects.create(
                 name = payload.name,
                 description = payload.description
            )
            return {"Success":"domain has been created"}
        except Exception as e:
            return {"error": str(e)}
        

class ProjectCycleService:

    def _check_admin(self, request):
        if request.user.role != "admin":
            raise HttpError(401, "Unauthorized: Admin access required.")
        return None

    # Service to create a new project cycle
    def create_cycle(self, payload: CreateProjectCycleSchema):
        
        active_cycle = ProjectCycleModel.objects.filter(is_active=True).first()
        if active_cycle:
            return {"error": "An active project cycle already exists."}

        try:
            # Create the cycle
            new_cycle = ProjectCycleModel.objects.create(
                cycle_name=payload.cycle_name,
                start_date=payload.start_date,
                end_date=payload.end_date,
                is_active=payload.is_active
            )
            return {"message": "Project cycle created successfully", "id": new_cycle.id}
        except Exception as e:
            return {"error": str(e)}

    # Service to list all project cycles
    def get_all_cycles(self):  
        try:
            cycles = ProjectCycleModel.objects.all()
            return [PCSchema.from_orm(cycle) for cycle in cycles]
        except Exception as e:
            return {"error": str(e)}

    # Service to update an existing project cycle
    def update_cycle(self, cycle, payload: UpdateProjectCycleSchema):
        try:
            cycle.cycle_name = payload.cycle_name
            cycle.start_date = payload.start_date
            cycle.end_date = payload.end_date
            cycle.is_active = payload.is_active
            cycle.save()

            
            return PCSchema.from_orm(cycle)
        except Exception as e:
            return {"error": str(e)}

    # Service to deactivate a project cycle
    def deactivate_project_cycle(self, request, cycle_id: int):
        self._check_admin(request)

        try:
            cycle = get_object_or_404(ProjectCycleModel, id=cycle_id)
            cycle.is_active = False
            cycle.save()
            return {"message": "Project cycle deactivated successfully"}
        except Exception as e:
            return {"error": str(e)}