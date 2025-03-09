# Django imports
from django.db import models

# Model imports
from members.models import CustomUser, FileModel


class DomainModel(models.Model):
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(max_length=256)


class ProjectModel(models.Model):
    ONGOING = 'ON'
    PAST = 'PA'

    STATUS_ROLES = [
        (ONGOING, 'ongoing'),
        (PAST, 'past'),
    ]

    name = models.CharField(max_length=64)
    description = models.TextField(max_length=256)
    github_link = models.URLField(null=True, blank=True)
    youtube_link = models.URLField(null=True, blank=True)
    status = models.CharField(choices=STATUS_ROLES, max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)
    pdf_report = models.ForeignKey(FileModel, on_delete=models.CASCADE, null=True)
    domain = models.ForeignKey(DomainModel, on_delete=models.CASCADE)


class TeamModel(models.Model):
    name = models.CharField(max_length=50)
    members = models.ManyToManyField(CustomUser)
    team_lead = models.ForeignKey(CustomUser, related_name='team_lead', on_delete=models.SET_NULL, null=True)
    domain = models.ForeignKey(DomainModel, on_delete=models.CASCADE) 


class TeamMembership(models.Model):
    project = models.ForeignKey(ProjectModel, on_delete=models.CASCADE)
    team = models.ForeignKey(TeamModel, on_delete=models.CASCADE)
    joined_at = models.DateTimeField(auto_now_add=True)


class SubmissionModel(models.Model):
    project = models.ForeignKey(ProjectModel, on_delete=models.CASCADE, null=True, blank=True)
    team = models.ForeignKey(TeamModel, on_delete=models.CASCADE)
    submitted_by = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    github_link = models.URLField()
    report_file = models.ForeignKey(FileModel, on_delete=models.CASCADE)
    submitted_at = models.DateTimeField(auto_now_add=True)


class ScrumModel(models.Model):
    meeting_link = models.URLField(max_length=500)
    domain = models.ForeignKey(DomainModel, on_delete=models.CASCADE)
    scheduled_time = models.DateField()


class ProjectCycleModel(models.Model):
    cycle_name = models.CharField(max_length=256)
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()
    application_start_time = models.DateTimeField()  
    application_end_time = models.DateTimeField()
    is_active = models.BooleanField()


