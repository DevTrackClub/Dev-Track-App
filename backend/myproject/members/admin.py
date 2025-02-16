from django.contrib import admin


from .models import CustomUser

@admin.register(CustomUser)
class CustomUserAdmin(admin.ModelAdmin):
    list_display = ("email", "first_name", "last_name", "srn", "is_active", "is_staff")
    search_fields = ("email", "srn")