from django.core.exceptions import PermissionDenied
from roles_permisos.models import RolPermiso, Permiso

def check_user_permissions(user, required_permissions):
    """
    Verifica si un usuario tiene los permisos necesarios para realizar una acción.

    :param user: Usuario autenticado
    :param required_permissions: Lista de nombres de permisos requeridos
    :raises PermissionDenied: Si el usuario no tiene los permisos necesarios o tiene el permiso `NoAccess`
    """
    if not user.is_authenticated:
        raise PermissionDenied("El usuario no está autenticado.")

    # Verificar si el usuario tiene el permiso especial 'NoAccess'
    no_access_permission = Permiso.objects.filter(name='NoAccess').first()
    if no_access_permission and RolPermiso.objects.filter(
        rol__rol_users__user=user, permiso=no_access_permission
    ).exists():
        raise PermissionDenied("El usuario tiene el permiso 'NoAccess', no puede realizar esta acción.")

    # Verificar si el usuario tiene al menos uno de los permisos requeridos
    has_permission = RolPermiso.objects.filter(
        rol__rol_users__user=user,
        permiso__name__in=required_permissions
    ).exists()

    if not has_permission:
        raise PermissionDenied(f"El usuario no tiene los permisos requeridos: {', '.join(required_permissions)}.")
