import datetime

from drf_spectacular.utils import extend_schema_view
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from clientes_ventas_cotizaciones.models import Venta
from clientes_ventas_cotizaciones.schemas import venta_list_schema, venta_create_schema
from clientes_ventas_cotizaciones.serializers.venta_serializers import VentaSerializer
from users.utils.permission_checker import check_user_permissions


@extend_schema_view(
    list=venta_list_schema,
    create=venta_create_schema
)
class VentaViewSet(viewsets.ModelViewSet):
    """
    ViewSet para manejar las ventas:
    - Listar todas las ventas.
    - Crear nuevas ventas (usuario en sesión asociado automáticamente).
    - Obtener ventas por ID.
    """
    queryset = Venta.objects.all()
    serializer_class = VentaSerializer
    permission_classes = [IsAuthenticated]

    def list(self, request, *args, **kwargs):
        # Verificar permisos antes de listar
        check_user_permissions(request.user, ['Ventas'])

        # Mostrar solo los campos relevantes, corrigiendo "fecha_venta"
        ventas = self.queryset.values(
            'id',
            'cliente__nombre',
            'cliente__apellido',
            'total',
            'fecha_venta',
            'usuario__username'
        )
        return Response(list(ventas))

    def create(self, request, *args, **kwargs):
        # Verificar permisos antes de crear
        check_user_permissions(request.user, ['Ventas'])

        # Asignar el usuario en sesión a la venta
        request_data = request.data.copy()
        request_data['usuario'] = request.user.id  # Asociar usuario en sesión

        # Asegurarse de que fecha_venta sea de tipo date
        if 'fecha_venta' in request_data and isinstance(request_data['fecha_venta'], datetime.datetime):
            request_data['fecha_venta'] = request_data['fecha_venta'].date()

        serializer = self.get_serializer(data=request_data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        return Response(serializer.data, status=201)
