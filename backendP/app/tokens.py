from rest_framework_simplejwt.authentication import JWTAuthentication

class CustomJWTAuthentication(JWTAuthentication):
    """
    Configuración personalizada para JWT Authentication.
    """
    def get_validated_token(self, raw_token):
        return super().get_validated_token(raw_token)
