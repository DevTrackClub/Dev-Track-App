from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser, FileModel

class CustomUserAdmin(UserAdmin):
    model = CustomUser
    list_display = ('email', 'first_name', 'last_name', 'role', 'is_active', 'is_staff', 'is_superuser')
    list_filter = ('role', 'is_active', 'is_staff', 'is_superuser')
    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        ('Personal Info', {'fields': ('first_name', 'last_name', 'phone', 'srn', 'branch', 'passout_year', 'github', 'linkedin')}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        ('OTP Details', {'fields': ('otp_token', 'otp_expiration')}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'password1', 'password2', 'role', 'is_staff', 'is_superuser')}
        ),
    )
    search_fields = ('email', 'first_name', 'last_name', 'srn')
    ordering = ('email',)
    filter_horizontal = ('groups', 'user_permissions',)

admin.site.register(CustomUser, CustomUserAdmin)

