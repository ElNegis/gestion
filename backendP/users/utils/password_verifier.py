import re

def is_valid_password(password: str) -> bool:
    if not password:
        return False

    # Verificar longitud mínima
    if len(password) < 12:
        return False

    # Verificar al menos una letra
    has_letter = bool(re.search(r'[a-zA-Z]', password))
    if not has_letter:
        return False

    # Verificar al menos un número
    has_number = bool(re.search(r'[0-9]', password))
    if not has_number:
        return False

    # Verificar al menos un carácter especial
    has_special = bool(re.search(r'[!@#$%^&*(),.?":{}|<>]', password))
    if not has_special:
        return False

    return True
