from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views.permiso_views import PermisoViewSet
from .views.rol_views import RolViewSet
from .views.rol_permiso_views import ObtenerPermisosDeRolView, get_user_permissions

# Configuración del router para ViewSets
router = DefaultRouter()
router.register(r'permisos', PermisoViewSet, basename='permiso')
router.register(r'roles', RolViewSet, basename='rol')

# URLs personalizadas adicionales
urlpatterns = [
    path('', include(router.urls)),
    path('roles/<int:rol_id>/permisos/', ObtenerPermisosDeRolView.as_view(), name='obtener_permisos_rol'),
    path('users/permissions/', get_user_permissions, name='get_user_permissions'),
    # Nuevo endpoint para obtener roles con permisos
    path('roles-con-permisos/', RolViewSet.as_view({'get': 'obtener_roles_con_permisos'}), name='roles_con_permisos'),
]
