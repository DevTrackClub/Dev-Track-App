from django.core.files.storage import default_storage
from collections import defaultdict
from .models import ProjectModel, ProjectCycleModel, TeamModel, DomainModel
from registrations.models import ProjectApplicationModel
from .schemas import CreateProjectSchema, ListProjectSchema, CreateDomainSchema, ListDomainSchema
from members.models import FileModel
from projects.models import DomainModel, ProjectCycleModel
from projects.schemas import CreateProjectCycleSchema, CreateDomainSchema
from registrations.models import ProjectApplicationModel
from django.shortcuts import get_object_or_404
from django.db import transaction
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
        



class TeamFormationService:
    @staticmethod
    def assign_teams():
        with transaction.atomic():  # Ensures all operations are atomic
            cycle = ProjectCycleModel.objects.filter(is_active=True).first()
            if not cycle:
                raise HttpError(400, "No active project cycle found")

            applications = ProjectApplicationModel.objects.filter(cycle=cycle).select_related("user", "first_preference", "second_preference")

            if not applications.exists():
                raise HttpError(400, "No project applications found for the active cycle")

            users_by_year = defaultdict(list)
            for app in applications:
                users_by_year[app.user.passout_year].append(app)

            assigned_teams = []

            for passout_year, users in users_by_year.items():
                teams = defaultdict(list)  # {domain_id: [teams]}
                remaining_users = defaultdict(list)  # Users needing placement

                # **Step 1: First Preference Allocation**
                for app in users:
                    domain_id = app.first_preference.id
                    placed = False

                    for team in teams[domain_id]:
                        if len(team) < 4:
                            team.append(app.user)
                            placed = True
                            break

                    if not placed:
                        remaining_users[domain_id].append(app.user)

                # **Step 2: Form New Teams for First Preference**
                for domain_id, unplaced_users in list(remaining_users.items()):
                    while len(unplaced_users) >= 3:
                        teams[domain_id].append(unplaced_users[:3])
                        unplaced_users = unplaced_users[3:]

                    remaining_users[domain_id] = unplaced_users

                # **Step 3: Assigning Second Preference**
                for domain_id, unplaced_users in list(remaining_users.items()):
                    for user in unplaced_users:
                        user_application = next(app for app in users if app.user == user)
                        second_pref_id = user_application.second_preference.id
                        placed = False

                        for team in teams[second_pref_id]:
                            if len(team) < 4:
                                team.append(user)
                                placed = True
                                break

                        if not placed:
                            remaining_users[second_pref_id].append(user)

                # **Step 4: Adjusting Team Sizes**
                for domain_id, team_list in teams.items():
                    for team in team_list:
                        while len(team) > 5:  # Handling overflows
                            extra_user = team.pop()
                            remaining_users[domain_id].append(extra_user)

                        if len(team) < 3:  # Handling undersized teams
                            merged = False
                            for other_team in team_list:
                                if other_team != team and len(other_team) < 4:
                                    other_team.extend(team)
                                    team_list.remove(team)
                                    merged = True
                                    break

                            if not merged:
                                remaining_users[domain_id].extend(team)
                                team_list.remove(team)

                # **Step 5: Final Allocation**
                for domain_id, unplaced_users in list(remaining_users.items()):
                    for user in unplaced_users:
                        user_application = next(app for app in users if app.user == user)
                        second_pref_id = user_application.second_preference.id

                        for team in teams[second_pref_id]:
                            if len(team) < 4:
                                team.append(user)
                                break
                        else:
                            for team in teams[domain_id]:
                                if len(team) < 4:
                                    team.append(user)
                                    break

                # **Step 6: Creating Teams in Database**
                for domain_id, team_list in teams.items():
                    domain = get_object_or_404(DomainModel, id=domain_id)
                    for members in team_list:
                        if len(members) >= 3:
                            team = TeamModel.objects.create(
                                team_domain=domain,
                            )
                            team.members.set(members)
                            assigned_teams.append(team)

            return {"message": "Teams assigned successfully", "teams": assigned_teams}
