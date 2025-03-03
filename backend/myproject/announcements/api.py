from django.shortcuts import get_object_or_404
from django.middleware.csrf import get_token
from ninja_extra import NinjaExtraAPI, ControllerBase, api_controller, route
from django.middleware.csrf import get_token
from django.core.paginator import Paginator
from .models import PostModel, NotificationModel
from . import schemas
from .schemas import PostSchema
from .services import AnnouncementService

@api_controller("/posts", tags="Posts")
class PostAPIController(ControllerBase):

    def _check_admin(self, request):
        # Check if the user is authenticated and has an admin role.
        if not request.user.is_authenticated or request.user.role != 'admin':
            return JsonResponse({"detail": "Admin privileges required"}, status=403)
        return None
    
    def _check_user(self, request):
        if not request.user.is_authenticated or request.user.role !='member':
            return JsonResponse({"detail": "User privileges required"}, status=403)
        return None

    # API endpoint to create a new post (admin only).
    @route.post("/add", url_name="Add Post")
    def create_post(self, request, payload: schemas.PostCreateSchema):
        admin_check = self.post_service._check_admin(request)
        if admin_check:
            return admin_check

        post = self.post_service.create_post(request, payload)
        return {
            "message": "Post created successfully",
            "post_id": post.id,
            "csrf_token": get_token(request)
        }

    # API endpoint to list all posts.
    @route.get("/", url_name="List Posts")
    def list_posts(self, request, page: int=1, per_page: int=10):
        posts = PostModel.objects.all().order_by("created_at")
        paginator=Paginator(posts,per_page)
        page_obj=paginator.get_page(page)

        return{
            "total_pages": paginator.num_pages, "current_page": page, "data": [
                {
                "id": post.id,
                "title": post.title,
                "description": post.description,
                "created_at": post.created_at.isoformat(),  
                "created_by": post.created_by.id,
            }
            for post in page_obj
        ],
        }
    
    @route.post("/notifications/", url_name="Notifications")
    def user_notifications(self, request, unread:bool=False, page: int = 1, per_page: int = 10):
            user=request.user
            result=self._check_user(request)
            if result is not None:
                return result

            notifications = NotificationModel.objects.filter(user=user, notification_type__in=["SC", "DE"])
            
            if unread:
                notifications = notifications.filter(is_read=False)
            else:
                notifications.update(is_read=True)

            notifications = notifications.order_by("-is_read", "-created_at")
            
            paginator=Paginator(notifications, per_page)
            page_obj=paginator.get_page(page)

            return {
                    "total_pages": paginator.num_pages,"current_page": page,
                    "notifications": [
                {
                    "id": notif.id,
                    "message": notif.message,
                    "is_read": notif.is_read,
                    "created_at": notif.created_at.isoformat(),
                }
                for notif in page_obj
            ]
            }
            
    @route.put("/{post_id}", url_name="Update Post", response=PostSchema)
    def update_post(self, request, post_id: int, payload: schemas.PostUpdateSchema):
        self.post_service._check_admin(request)
        post = get_object_or_404(PostModel, id=post_id)
        post = self.post_service.update_post(post, payload)
        return schemas.PostSchema.from_orm(post)

    # API endpoint to delete a post (admin only).
    @route.delete("/{post_id}", url_name="Delete Post")
    def delete_post(self, request, post_id: int):
        admin_check = self.post_service._check_admin(request)
        if admin_check:
            return admin_check

        post = get_object_or_404(PostModel, id=post_id)
        self.post_service.delete_post(post)
        return {"message": "Post deleted successfully"}

# Register the PostAPIController with your NinjaExtraAPI instance.
api = NinjaExtraAPI(csrf=False)
