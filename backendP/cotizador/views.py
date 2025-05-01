from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
from .models import Plancha, Proveedor, CortePlegado
from .serializers import PlanchaSerializer, ProveedorSerializer, CortePlegadoSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from drf_spectacular.utils import extend_schema, OpenApiExample
from rest_framework.response import Response
from rest_framework import status
from users.utils.permission_checker import check_user_permissions
from users.utils.log_util import makelog  # Importar makelog


# CortePlegado
@extend_schema(
    tags=['CortePlegado']
)
class CortePlegadoUpdateDestroyApiView(RetrieveUpdateDestroyAPIView):
    queryset = CortePlegado.objects.all()
    serializer_class = CortePlegadoSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def update(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Planchas'])  # Verificar permisos
        response = super().update(request, *args, **kwargs)
        makelog(request.user, "corte_plegado/update", "PUT", data=request.data)  # Log de actualización
        return Response({
            "message": "CortePlegado actualizado correctamente.",
            "data": response.data
        }, status=status.HTTP_200_OK)

    def destroy(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Planchas'])  # Verificar permisos
        instance = self.get_object()
        instance.delete()
        makelog(request.user, "corte_plegado/delete", "DELETE", object_id=instance.id)  # Log de eliminación
        return Response({"message": "CortePlegado eliminado correctamente."}, status=status.HTTP_200_OK)


@extend_schema(
    tags=['CortePlegado']
)
class CortePlegadoListView(ListCreateAPIView):
    queryset = CortePlegado.objects.all()
    serializer_class = CortePlegadoSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Planchas'])  # Verificar permisos
        makelog(request.user, "corte_plegado/list", "GET")  # Log de listado
        return super().get(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Planchas'])  # Verificar permisos
        makelog(request.user, "corte_plegado/create", "POST", data=request.data)  # Log de creación
        return super().post(request, *args, **kwargs)


# Planchas
@extend_schema(
    tags=['Planchas'],
    request=PlanchaSerializer,
    responses=PlanchaSerializer,
    examples=[
        OpenApiExample(
            'Crear Plancha',
            summary='Ejemplo de creación de plancha',
            description='Incluye los datos de espesor, largo, ancho, precio y proveedor.',
            value={
                "espesor": 10.5,
                "largo": 2000,
                "ancho": 1000,
                "precio_valor": 1500,
                "proveedor_id": 1
            }
        )
    ]
)
class PlanchaListCreateAPIView(ListCreateAPIView):
    queryset = Plancha.objects.all()
    serializer_class = PlanchaSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Planchas'])  # Verificar permisos
        makelog(request.user, "planchas/list", "GET")  # Log de listado
        return super().get(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Planchas'])  # Verificar permisos
        makelog(request.user, "planchas/create", "POST", data=request.data)  # Log de creación
        return super().post(request, *args, **kwargs)


@extend_schema(
    tags=['Planchas'],
    responses=PlanchaSerializer
)
class PlanchaRetrieveUpdateDestroyAPIView(RetrieveUpdateDestroyAPIView):
    queryset = Plancha.objects.all()
    serializer_class = PlanchaSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def update(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Planchas'])  # Verificar permisos
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        makelog(request.user, "planchas/update", "PUT", data=request.data)  # Log de actualización
        return Response({
            "message": "Plancha actualizada correctamente.",
            "data": serializer.data
        }, status=status.HTTP_200_OK)

    def destroy(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Planchas'])  # Verificar permisos
        instance = self.get_object()
        instance.delete()
        makelog(request.user, "planchas/delete", "DELETE", object_id=instance.id)  # Log de eliminación
        return Response({"message": "Plancha eliminada correctamente."}, status=status.HTTP_200_OK)


# Proveedores
@extend_schema(
    tags=['proveedor']
)
class ProveedorListCreateAPIView(ListCreateAPIView):
    queryset = Proveedor.objects.all()
    serializer_class = ProveedorSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Planchas'])  # Verificar permisos
        makelog(request.user, "proveedor/list", "GET")  # Log de listado
        return super().get(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Planchas'])  # Verificar permisos
        makelog(request.user, "proveedor/create", "POST", data=request.data)  # Log de creación
        return super().post(request, *args, **kwargs)


@extend_schema(
    tags=['proveedor']
)
class ProveedorRetrieveUpdateDestroyAPIView(RetrieveUpdateDestroyAPIView):
    queryset = Proveedor.objects.all()
    serializer_class = ProveedorSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def update(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Planchas'])  # Verificar permisos
        response = super().update(request, *args, **kwargs)
        makelog(request.user, "proveedor/update", "PUT", data=request.data)  # Log de actualización
        return Response({
            "message": "Proveedor actualizado correctamente.",
            "data": response.data
        }, status=status.HTTP_200_OK)

    def destroy(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Planchas'])  # Verificar permisos
        instance = self.get_object()
        instance.delete()
        makelog(request.user, "proveedor/delete", "DELETE", object_id=instance.id)  # Log de eliminación
        return Response({"message": "Proveedor eliminado correctamente."}, status=status.HTTP_200_OK)
