from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from users.models import User


class Admin(UserAdmin):
    list_display = ['username', 'email', 'date_joined', 'last_login', 'is_staff']
    search_fields = ['username', 'email']
    readonly_fields = ['last_login']

    filter_horizontal = ()
    list_filter = ()
    fieldsets = ()


admin.site.register(User, Admin)