from rest_framework_simplejwt.views import TokenRefreshView
from drf_spectacular.utils import extend_schema_view, extend_schema

@extend_schema_view(
    post=extend_schema(
        tags=["HealthCheck"],
        operation_id="TokenRefresh",
        summary="Refresca el Access Token",
        description="Renueva el Access Token utilizando un Refresh Token válido.",
        responses={200: {"type": "object", "properties": {"access": {"type": "string", "example": "<new_access_token>"}}}},
    )
)
class CustomTokenRefreshView(TokenRefreshView):
    pass
