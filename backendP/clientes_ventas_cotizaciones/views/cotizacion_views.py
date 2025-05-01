from drf_spectacular.utils import extend_schema_view
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from clientes_ventas_cotizaciones.models import Cotizacion
from clientes_ventas_cotizaciones.schemas import cotizacion_list_schema, cotizacion_create_schema
from clientes_ventas_cotizaciones.serializers.cotizacion_serializers import CotizacionSerializer
from users.utils.permission_checker import check_user_permissions


@extend_schema_view(
    list=cotizacion_list_schema,
    create=cotizacion_create_schema
)
class CotizacionViewSet(viewsets.ModelViewSet):
    """
    ViewSet para manejar las cotizaciones:
    - Listar todas las cotizaciones con detalles relacionados.
    - Crear nuevas cotizaciones (sin permitir fecha_cotizacion en la solicitud).
    """
    queryset = Cotizacion.objects.all()
    serializer_class = CotizacionSerializer
    permission_classes = [IsAuthenticated]

    def list(self, request, *args, **kwargs):
        # Verificar permisos antes de listar
        check_user_permissions(request.user, ['Ventas'])

        # Preparar datos relacionados para el listado
        cotizaciones = self.queryset.select_related(
            'plancha', 'corte_plegado'
        ).values(
            'id',
            'pieza',
            'precio',
            'fecha_cotizacion',
            'total_estimado',
            'detalles',
            'corte_plegado__espesor',
            'corte_plegado__largo',
            'corte_plegado__precio',
            'plancha__espesor',
            'plancha__largo',
            'plancha__ancho',
            'venta__total'
        )

        cotizaciones_detalladas = [
            {
                "id": cot["id"],
                "pieza": cot["pieza"],
                "precio": cot["precio"],
                "fecha_cotizacion": cot["fecha_cotizacion"],
                "total_estimado": cot["total_estimado"],
                "detalles": cot["detalles"],
                "corte_plegado": {
                    "espesor": cot["corte_plegado__espesor"],
                    "largo": cot["corte_plegado__largo"],
                    "precio": cot["corte_plegado__precio"]
                },
                "plancha": {
                    "espesor": cot["plancha__espesor"],
                    "largo": cot["plancha__largo"],
                    "ancho": cot["plancha__ancho"]
                },
                "venta_total": cot["venta__total"]
            }
            for cot in cotizaciones
        ]

        return Response(cotizaciones_detalladas)

    def create(self, request, *args, **kwargs):
        # Verificar permisos antes de crear
        check_user_permissions(request.user, ['Ventas'])

        # Eliminar fecha_cotizacion de la solicitud si está presente
        request_data = request.data.copy()
        if 'fecha_cotizacion' in request_data:
            request_data.pop('fecha_cotizacion')

        # Crear la cotización
        serializer = self.get_serializer(data=request_data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        return Response(serializer.data, status=201)

