from django.core.exceptions import ValidationError
from django.utils.translation import gettext as _
import os

class SpanishCommonPasswordValidator:
    def __init__(self, blacklist_path=None):
        # Asegurar la ruta correcta del archivo de contraseñas
        if blacklist_path is None:
            self.blacklist_path = os.path.join(os.path.dirname(__file__), "password_blacklist_es.txt")
        else:
            self.blacklist_path = blacklist_path

        # Cargar la lista negra de contraseñas
        try:
            with open(self.blacklist_path, "r", encoding="utf-8") as f:
                self.blacklist = {line.strip().lower() for line in f}
        except FileNotFoundError:
            self.blacklist = set()

    def validate(self, password, user=None):
        """Valida si la contraseña está en la lista negra."""
        if password.lower() in self.blacklist:
            raise ValidationError(
                _("Esta contraseña es demasiado común. Por favor elige otra."),
                code='password_too_common',
            )

    def get_help_text(self):
        """Texto de ayuda que se muestra en la UI de Django."""
        return _("Tu contraseña no puede estar en la lista de contraseñas más utilizadas en español.")
