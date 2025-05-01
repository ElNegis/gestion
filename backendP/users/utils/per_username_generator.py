from django.contrib.auth import get_user_model
import re

User = get_user_model()

def generate_username(nombre, apellido):
    """
    Genera un username único basado en el nombre y apellido del usuario.
    """
    nombre_inicial = nombre[0].lower()
    apellido = re.sub(r'\s+', '', apellido.lower())
    base_username = f"{nombre_inicial}{apellido}"
    counter = 1
    username = f"{base_username}{counter:02d}"

    while User.objects.filter(username=username).exists():
        counter += 1
        username = f"{base_username}{counter:02d}"

    return username
