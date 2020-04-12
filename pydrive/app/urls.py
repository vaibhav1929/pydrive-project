"""pydrive URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.0/topics/http/urls/
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
from django.conf import settings
from django.conf.urls.static import static
from app import views

urlpatterns = [
    path('', views.home, name='index'),
    path('get_entry', views.get_entry, name='home'),
    path('verify', views.verify, name='verify'),
    path('validate_otp', views.validate_otp, name='validate_otp'),
    path('dashboard', views.dashboard, name='dashboard'),
    path('upload_files', views.upload_files, name='upload_files'),
    path('save_folder', views.save_folder, name='save_folder'),
    path('file_provider/', views.file_provider, name='file_provider'),
    path('folder_provider/',views.folder_provider, name='folder_provider'),
    path('file_download',views.file_download, name='file_download'),
    path('folder_download', views.download_folder,name='folder_download'),
    path('toggle_star', views.toggle_star, name='toggle_star'),
    path('toggle_folder_star',views.toggle_star_folder,name='toggle_folder_star'),
    path('delete', views.delete_file, name='delete'),
    path('delete_folder',views.delete_folder, name='delete_folder'),
    path('get_shared',views.get_shared,name='get_shared'),
    path('check_share',views.check_share,name='check_share'),
    path('revoke_share',views.revoke_share,name="revoke_share"),
    path('shared_file_provider',views.shared_file_provider,name='shared_file_provider'),
    path('shared_folder_provider',views.shared_folder_provider,name='shared_file_provider'),
    path('shared_dashboard',views.render_shared,name='shared_dashboard'),
    path('forgot_password',views.forgot_password, name='forgot_password'),
    path('change_psw', views.change_psw, name='change_psw'),
    path('auth_vault', views.auth_vault, name='auth_vault'),
    path('vault', views.vault, name='vault'),
    path('vault_dashboard', views.vault_dashboard, name='vault_dashboard'),
    path('toggle_hide', views.toggle_hide, name='toggle_hide'),
    path('settings', views.settings, name='profile'),
    path('logout', views.logout, name='logout')
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
