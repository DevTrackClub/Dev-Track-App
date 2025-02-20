from django.shortcuts import get_object_or_404
from django.http import JsonResponse
from ninja_extra import NinjaExtraAPI, ControllerBase, api_controller, route
from django.middleware.csrf import get_token
from .models import PostModel
from . import schemas
from .schemas import PostSchema

@api_controller("/posts", tags="Posts")
class PostAPIController(ControllerBase):

    def _check_admin(self, request):
        # Check if the user is authenticated and has an admin role.
        if not request.user.is_authenticated or request.user.role != 'admin':
            return JsonResponse({"detail": "Admin privileges required"}, status=403)
        return None

    # API endpoint to create a new post (admin only).
    @route.post("/add", url_name="Add Post")
    def create_post(self, request, payload: schemas.PostCreateSchema):
        admin_check = self._check_admin(request)
        if admin_check:
            return admin_check
        
        post = PostModel.objects.create(
            title=payload.title,
            description=payload.description,
            created_by=request.user
        )
        return {
            "message": "Post created successfully",
            "post_id": post.id,
            "csrf_token": get_token(request)
        }

    # API endpoint to list all posts.
    @route.get("/", url_name="List Posts")
    def list_posts(self, request):
        posts = PostModel.objects.all().order_by("created_at")

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
    

    @route.put("/{post_id}", url_name="Update Post", response=PostSchema)
    def update_post(self, request, post_id: int, payload: schemas.PostUpdateSchema):
        admin_check = self._check_admin(request)
        if admin_check:
            return admin_check

        post = get_object_or_404(PostModel, id=post_id)
        if payload.title is not None:
            post.title = payload.title
        if payload.description is not None:
            post.description = payload.description
        post.save()
        # Convert to schema:
        return schemas.PostSchema.from_orm(post)


    # API endpoint to delete a post (admin only).
    @route.delete("/{post_id}", url_name="Delete Post")
    def delete_post(self, request, post_id: int):
        admin_check = self._check_admin(request)
        if admin_check:
            return admin_check
        
        post = get_object_or_404(PostModel, id=post_id)
        
        post.delete()
        return {"message": "Post deleted successfully"}

# Register the PostAPIController with your NinjaExtraAPI instance.
api = NinjaExtraAPI(csrf=False)
