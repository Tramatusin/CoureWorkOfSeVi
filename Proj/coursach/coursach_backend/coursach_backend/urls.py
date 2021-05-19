"""coursach_backend URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from users import views as user_views

from django.conf.urls import url
from rest_framework_swagger.views import get_swagger_view

from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi

schema_view = get_schema_view(
   openapi.Info(
      title="Snippets API",
      default_version='v1',
      description="Test description",
      terms_of_service="https://www.google.com/policies/terms/",
      contact=openapi.Contact(email="contact@snippets.local"),
      license=openapi.License(name="BSD License"),
   ),
   public=True,
   permission_classes=(permissions.AllowAny,),
)

urlpatterns = [
    path('swagger/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),

    path('admin/', admin.site.urls),
    path('register/', user_views.register, name='register-ref'),
    path('authenticate/', user_views.post_auth, name='auth-ref'),
    path('change_password/', user_views.post_change_password, name='change_password-ref'),
    path('set_favourite_manga/', user_views.set_favourite_manga, name='set_manga-ref'),
    path('get_favourite_manga/', user_views.get_favourite_manga, name='get_manga-ref'),
    path('getmanga/', user_views.get_manga, name='getmanga-ref'),
    path('ongoings/', user_views.get_ongoings, name='ongoings-ref'),
    path('new/', user_views.get_new_manga, name='new_manga-ref'),
    path('getmanga/page/', user_views.get_manga_page, name='getmanga_page-ref'),
    path('getmanga/chapter/', user_views.get_manga_page_urls, name='getmanga_page_urls-ref'),
    path('getlist/', user_views.get_list, name='getlist-ref'),
    path('register/post/', user_views.post_register, name='register_post-ref'),
    path('', include('authorization.urls')),
]
