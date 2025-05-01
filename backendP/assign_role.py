import os
import django

# Configuración de Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.settings')
django.setup()

from django.contrib.auth import get_user_model
from roles_permisos.models import Rol

# Modelo de Usuario
User = get_user_model()

# Variables de entorno o valores predeterminados
USER_ID = int(os.getenv('ASSIGN_ROLE_USER_ID', 1))
ROLE_ID = int(os.getenv('ASSIGN_ROLE_ROLE_ID', 1))

try:
    # Obtener el usuario por ID
    user = User.objects.get(id=USER_ID)
except User.DoesNotExist:
    print(f"Error: No se encontró el usuario con ID {USER_ID}.")
    exit(1)

try:
    # Obtener el rol por ID
    role = Rol.objects.get(id=ROLE_ID)
except Rol.DoesNotExist:
    print(f"Error: No se encontró el rol con ID {ROLE_ID}.")
    exit(1)

# Asignar el rol al usuario
if not user.roles.filter(id=ROLE_ID).exists():
    user.roles.add(role)
    print(f"Rol '{role.name}' asignado exitosamente al usuario '{user.username}'.")
else:
    print(f"El usuario '{user.username}' ya tiene asignado el rol '{role.name}'.")
