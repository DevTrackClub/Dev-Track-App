from django.shortcuts import get_object_or_404
from django.middleware.csrf import get_token
from ninja_extra import NinjaExtraAPI, ControllerBase, api_controller, route
from .models import PostModel
from . import schemas
from .schemas import PostSchema
from .services import AnnouncementService

@api_controller("/posts", tags="Posts")
class PostAPIController(ControllerBase):
    def __init__(self) -> None:
        self.post_service = AnnouncementService()

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
    def list_posts(self, request):
        return self.post_service.list_posts()

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
