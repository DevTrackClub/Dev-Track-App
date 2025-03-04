from django.shortcuts import get_object_or_404
from .models import PostModel
from ninja.errors import HttpError

class AnnouncementService:
    def _check_admin(self, request):
        if request.user.role != "admin":
            raise HttpError(401, "Unauthorized: Admin access required.")
        return None

    def create_post(self, request, payload):
        post = PostModel.objects.create(
            title=payload.title,
            description=payload.description,
            created_by=request.user
        )
        return post

    def list_posts(self):
        posts = PostModel.objects.all().order_by("-created_at")
        result = [
            {
                "id": post.id,
                "title": post.title,
                "description": post.description,
                "created_at": post.created_at.isoformat(),
                "created_by": post.created_by.id,
            }
            for post in posts
        ]
        return result

    def update_post(self, post, payload):
        if payload.title is not None:
            post.title = payload.title
        if payload.description is not None:
            post.description = payload.description
        post.save()
        return post

    def delete_post(self, post):
        post.delete()
