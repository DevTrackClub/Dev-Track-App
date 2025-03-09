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
                temp_remaining_users = defaultdict(list)
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
                            temp_remaining_users[second_pref_id].append(user)

                remaining_users = temp_remaining_users  # Update remaining users

                # **Step 4: Adjusting Team Sizes**
                for domain_id, team_list in teams.items():
                    for team in team_list:
                        while len(team) > 5:  # Overflow case
                            extra_user = team.pop()
                            remaining_users[domain_id].append(extra_user)
                        
                        while len(team) < 5 and remaining_users[domain_id]:  # Fill up to 5 if possible
                            team.append(remaining_users[domain_id].pop(0))

                # **Step 5: Ensure Users Return to First Preference if Second Preference Fails**
                temp_remaining_users = defaultdict(list)
                for domain_id, unplaced_users in list(remaining_users.items()):
                    for user in unplaced_users:
                        user_application = next(app for app in users if app.user == user)
                        first_pref_id = user_application.first_preference.id
                        second_pref_id = user_application.second_preference.id

                        placed = False
                        for team in teams[first_pref_id]:  # Try first preference again
                            if len(team) < 4:
                                team.append(user)
                                placed = True
                                break

                        # **Newly added logic: Allow a single team to go up to 5 members if no space is found**
                        if not placed:
                            for team in teams[first_pref_id]: 
                                if len(team) == 4:      # Allow one team to expand to 5 members
                                    team.append(user)
                                    placed = True
                                    break
                                
                        # **If no space in first preference, try second preference again**
                        if not placed:
                            for team in teams[second_pref_id]: 
                                if len(team) < 4:      # Allow one team to expand to 5 members
                                    team.append(user)
                                    placed = True
                                    break


                        if not placed:
                            temp_remaining_users[first_pref_id].append(user)  # Keep in first preference pool

                remaining_users = temp_remaining_users  # Update unplaced users

                # **Step 6: Creating Teams in Database**
                for domain_id, team_list in teams.items():
                    domain = get_object_or_404(DomainModel, id=domain_id)
                    team_count = TeamModel.objects.filter(domain=domain).count()
                    for index, members in enumerate(team_list, start=1):
                        if len(members) >= 3:
                            team_name = f"Team {domain.name} {team_count + index}"  
                            team = TeamModel.objects.create(
                                name=team_name,
                                domain=domain
                            )
                            team.members.set(members)
                            assigned_teams.append(team)


                            # **Step 7: Handling Completely Unplaced Users**
                            for domain_id, unplaced_users in remaining_users.items():
                                domain = get_object_or_404(DomainModel, id=domain_id)
                                team_count = TeamModel.objects.filter(domain=domain).count()

                                while len(unplaced_users) >= 3:  # Form new teams if possible
                                    team_name = f"Leftover Team {domain.name} {team_count + 1}"
                                    team = TeamModel.objects.create(
                                        name=team_name,
                                        domain=domain
                                    )
                                    team.members.set(unplaced_users[:3])  # Assign first 3 users
                                    assigned_teams.append(team)
                                    unplaced_users = unplaced_users[3:]  # Remove placed users

                                # If there are still 1 or 2 users left, try to place them in teams with <5 members
                                for team in TeamModel.objects.filter(domain=domain):
                                    while len(unplaced_users) > 0 and team.members.count() < 5:
                                        user = unplaced_users.pop(0)
                                        team.members.add(user)

                            # If users are still unplaced, log them or handle manually
                            if any(remaining_users.values()):
                                unplaced_user_list = [user.email for users in remaining_users.values() for user in users]
                                print(f"Warning: The following users could not be placed in a team: {unplaced_user_list}")

            
            return {"message": "Teams assigned successfully", "teams": assigned_teams}
