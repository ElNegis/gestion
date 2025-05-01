from django.core.exceptions import PermissionDenied
from roles_permisos.models import Rol, Permiso, RolPermiso
from users.models import User, UserRol
from users.utils import check_user_permissions


def assign_role_to_user(user_id, role_id, request):

    user = User.objects.filter(id=user_id).first()
    rol = Rol.objects.filter(id=role_id).first()

    if not user:
        raise ValueError(f"El usuario con id {user_id} no existe.")
    if not rol:
        raise ValueError(f"El rol con id {role_id} no existe.")

    UserRol.objects.get_or_create(user=user, rol=rol)
    return {"status": "Rol asignado correctamente."}

def remove_role_from_user(user_id, role_id, request):



    user = User.objects.filter(id=user_id).first()
    rol = Rol.objects.filter(id=role_id).first()

    if not user:
        raise ValueError(f"El usuario con id {user_id} no existe.")
    if not rol:
        raise ValueError(f"El rol con id {role_id} no existe.")

    deleted_count, _ = UserRol.objects.filter(user=user, rol=rol).delete()
    if deleted_count == 0:
        return {"status": "El usuario no tenía asignado este rol."}

    return {"status": "Rol eliminado correctamente."}
