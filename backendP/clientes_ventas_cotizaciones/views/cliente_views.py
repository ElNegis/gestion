from drf_spectacular.utils import extend_schema_view
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.exceptions import PermissionDenied
from clientes_ventas_cotizaciones.models import Cliente
from clientes_ventas_cotizaciones.schemas import (
    cliente_create_schema, cliente_list_schema, cliente_update_schema, cliente_destroy_schema
)
from clientes_ventas_cotizaciones.serializers.cliente_serializers import ClienteSerializer
from users.utils.permission_checker import check_user_permissions


@extend_schema_view(
    list=cliente_list_schema,
    create=cliente_create_schema,
    update=cliente_update_schema,
    destroy=cliente_destroy_schema
)
class ClienteViewSet(viewsets.ModelViewSet):
    queryset = Cliente.objects.all()
    serializer_class = ClienteSerializer
    permission_classes = [IsAuthenticated]

    def create(self, request, *args, **kwargs):
        # Verificar permisos antes de crear
        check_user_permissions(request.user, ['Ventas'])

        # Excluir el campo 'codigo_clien' del request
        request_data = request.data.copy()
        request_data.pop('codigo_clien', None)

        serializer = self.get_serializer(data=request_data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        return Response(serializer.data)

    def update(self, request, *args, **kwargs):
        # Verificar permisos antes de actualizar
        check_user_permissions(request.user, ['Ventas'])

        # Excluir el campo 'codigo_clien' del request
        request_data = request.data.copy()
        request_data.pop('codigo_clien', None)

        serializer = self.get_serializer(
            instance=self.get_object(), data=request_data, partial=kwargs.get('partial', False)
        )
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response(serializer.data)

    def list(self, request, *args, **kwargs):
        # Verificar permisos antes de listar
        check_user_permissions(request.user, ['Ventas'])

        # Mostrar solo los campos relevantes, incluyendo id y codigo_clien
        clientes = self.queryset.values('id', 'codigo_clien', 'nombre', 'apellido', 'email', 'telefono')
        return Response(list(clientes))
