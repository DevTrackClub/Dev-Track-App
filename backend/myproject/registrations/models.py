from django.db import models
from members.models import CustomUser
from projects.models import DomainModel, ProjectCycleModel, TeamModel
# Create your models here.


class ProjectApplicationModel(models.Model):

    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    cycle = models.ForeignKey(ProjectCycleModel, on_delete=models.CASCADE)
    first_preference = models.ForeignKey(DomainModel, related_name="first_pref", on_delete=models.CASCADE)
    second_preference = models.ForeignKey(DomainModel, related_name="second_pref", on_delete=models.CASCADE)
    application_date = models.DateTimeField(auto_now_add=True)
    selected_team = models.ForeignKey(TeamModel, on_delete=models.SET_NULL, null=True, blank=True)





