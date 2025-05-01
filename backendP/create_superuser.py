import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.settings')
django.setup()

from django.contrib.auth import get_user_model
from roles_permisos.models import Rol, Permiso, RolPermiso

User = get_user_model()

# Variables de entorno para los detalles del superusuario
SUPERUSER_USERNAME = os.getenv('SUPERUSER_USERNAME', 'admin')
SUPERUSER_PASSWORD = os.getenv('SUPERUSER_PASSWORD', 'adminpassword')
SUPERUSER_NOMBRE = os.getenv('SUPERUSER_NOMBRE', 'Admin')
SUPERUSER_APELLIDO = os.getenv('SUPERUSER_APELLIDO', 'User')

# Crear o recuperar el rol 'OnlyAdmin'
only_admin_role, created = Rol.objects.get_or_create(
    name='OnlyAdmin',
    defaults={'description': 'Solamente Administrador'}
)

# Obtener todos los permisos excepto 'NoAccess'
excluded_permission = Permiso.objects.filter(name='NoAccess').first()
all_permissions = Permiso.objects.exclude(id=excluded_permission.id) if excluded_permission else Permiso.objects.all()

# Asignar permisos al rol 'OnlyAdmin'
for permiso in all_permissions:
    RolPermiso.objects.get_or_create(rol=only_admin_role, permiso=permiso)

# Crear el superusuario si no existe
if not User.objects.filter(username=SUPERUSER_USERNAME).exists():
    superuser = User.objects.create(
        username=SUPERUSER_USERNAME,
        password=SUPERUSER_PASSWORD,
        nombre=SUPERUSER_NOMBRE,
        apellido=SUPERUSER_APELLIDO,
        is_active=True,
    )
    superuser.roles.add(only_admin_role)
    superuser.save()
    print(f'Superusuario "{SUPERUSER_USERNAME}" creado exitosamente y asignado al rol "{only_admin_role.name}".')
else:
    print(f'Superusuario "{SUPERUSER_USERNAME}" ya existe.')
