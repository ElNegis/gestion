from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from drf_spectacular.utils import extend_schema
from users.utils import check_user_permissions
from ..models import Logs
from ..serializers import LogsSerializer

class LogsAplicativosView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        tags=["Logs"],
        operation_id="Obtener Logs Aplicativos",
        summary="Obtiene todos los logs de aplicativos",
        description="Devuelve una lista de todos los logs de tipo aplicativo con su ID, mensaje y fecha/hora.",
        responses={200: LogsSerializer(many=True)}
    )
    def get(self, request):
        check_user_permissions(request.user, ['Logs'])
        logs = Logs.objects.filter(tipo='aplicativo').order_by('-fecha_hora')
        serializer = LogsSerializer(logs, many=True)
        return Response(serializer.data)


class LogsSeguridadView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        tags=["Logs"],
        operation_id="Obtener Logs Seguridad",
        summary="Obtiene todos los logs de seguridad",
        description="Devuelve una lista de todos los logs de tipo seguridad con su ID, mensaje y fecha/hora.",
        responses={200: LogsSerializer(many=True)}
    )
    def get(self, request):
        check_user_permissions(request.user, ['Logs'])
        logs = Logs.objects.filter(tipo='Seguridad').order_by('-fecha_hora')
        serializer = LogsSerializer(logs, many=True)
        return Response(serializer.data)
