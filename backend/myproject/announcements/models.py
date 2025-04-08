from django.db import models

from members.models import CustomUser
# Create your models here.



class PostModel(models.Model): 
    title = models.CharField(max_length=100, blank=False, null=False)
    description = models.TextField(max_length=512, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    created_by = models.ForeignKey(CustomUser, on_delete=models.CASCADE)

 
class NotificationModel(models.Model):
    ENROLLMENT = 'EN'
    SCRUM = 'SC'
    DEADLINE = 'DE'

    NOTIF_TYPE = [
        (ENROLLMENT, 'enrollment'),
        (SCRUM, 'scrum'),
        (DEADLINE, 'deadline'),
    ]

    message = models.CharField(max_length=200)
    created_at = models.DateTimeField(auto_now_add=True)
    is_read = models.BooleanField(default=False)
    notification_type = models.CharField(max_length=2, choices=NOTIF_TYPE)
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)





