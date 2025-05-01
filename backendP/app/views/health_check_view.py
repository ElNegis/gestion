from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from drf_spectacular.utils import extend_schema

@extend_schema(
    tags=["HealthCheck"],
    summary="Verifica la conexión con el servidor",
    description="Devuelve un mensaje de éxito si el servidor está funcionando correctamente.",
    responses={200: {"type": "object", "properties": {"status": {"type": "string", "example": "OK"}}}},
)
class HealthCheckView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        return Response({"status": "OK"}, status=200)
