from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from drf_spectacular.utils import extend_schema_view

from users.models import UserRol
from users.utils import makelog
from users.utils import check_user_permissions
from ..models import Rol, RolPermiso, Permiso
from ..serializers import RolSerializer
from ..schemas import (
    list_roles_schema, create_role_schema, update_role_schema, delete_role_schema,
    patch_rol_schema, get_rol_schema, asignar_permiso_schema, eliminar_permiso_schema,
    obtener_roles_con_permisos_schema, obtener_roles_sin_permisos_schema
)

@extend_schema_view(
    list=list_roles_schema,
    create=create_role_schema,
    update=update_role_schema,
    destroy=delete_role_schema,
    partial_update=patch_rol_schema,
    retrieve=get_rol_schema,
)
class RolViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = Rol.objects.all()
    serializer_class = RolSerializer

    def list(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Users'])
        makelog(request.user, "roles/list", "GET")
        return super().list(request, *args, **kwargs)

    def create(self, request, *args, **kwargs):

        check_user_permissions(request.user, ['Users'])
        makelog(request.user, "roles/create", "POST", data=request.data,tipo="Seguridad")
        return super().create(request, *args, **kwargs)

    def update(self, request, *args, **kwargs):

        check_user_permissions(request.user, ['Users'])
        makelog(request.user, f"roles/{kwargs.get('pk')}/update", "PUT", data=request.data,tipo="Seguridad")
        return super().update(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Users'])
        makelog(request.user, f"roles/{kwargs.get('pk')}/delete", "DELETE",tipo="Seguridad")
        return super().destroy(request, *args, **kwargs)

#--------------------------------------
# MANEJO DE PERMISOS
#--------------------------------------
    @asignar_permiso_schema
    @action(detail=False, methods=['post'], url_path="asignar-permiso")
    def asignar_permiso(self, request):
        print("Inicio de asignar_permiso")
        check_user_permissions(request.user, ['Users'])

        rol_id = request.data.get('rol_id')
        permiso_id = request.data.get('permiso_id')

        print(f"Datos recibidos - rol_id: {rol_id}, permiso_id: {permiso_id}")

        if not rol_id or not permiso_id:
            print("Error: Falta rol_id o permiso_id")
            return Response({"error": "Los campos 'rol_id' y 'permiso_id' son obligatorios."}, status=400)

        rol = Rol.objects.filter(id=rol_id).first()
        permiso = Permiso.objects.filter(id=permiso_id).first()

        print(f"Objeto rol encontrado: {rol}, Objeto permiso encontrado: {permiso}")

        if not rol:
            print(f"Error: Rol con id {rol_id} no encontrado")
            return Response({"error": f"Rol con id {rol_id} no encontrado."}, status=400)
        if not permiso:
            print(f"Error: Permiso con id {permiso_id} no encontrado")
            return Response({"error": f"Permiso con id {permiso_id} no encontrado."}, status=400)

        # Obtener el rol del usuario correctamente
        user_rol = UserRol.objects.filter(user=request.user).first()
        print(f"Rol del usuario autenticado: {user_rol}")

        if user_rol and user_rol.rol.id == rol.id:
            print("Error: El usuario intenta modificar los permisos de su propio rol")
            return Response({"error": "No puedes modificar los permisos de tu propio rol."}, status=400)

        # Restricción 2: No más de dos permisos por rol
        cantidad_permisos = rol.permisos.count()
        print(f"Cantidad de permisos en el rol: {cantidad_permisos}")
        if cantidad_permisos >= 2:
            print("Error: Intento de asignar más de dos permisos a un rol")
            return Response({"error": "No puedes asignar más de dos permisos a un rol."}, status=400)

        if RolPermiso.objects.filter(rol=rol, permiso=permiso).exists():
            print("Error: El permiso ya está asignado a este rol")
            return Response({"error": "El permiso ya está asignado a este rol."}, status=400)

        # Asignación del permiso
        print("Asignando permiso...")
        RolPermiso.objects.create(rol=rol, permiso=permiso)
        makelog(request.user, "roles/asignar-permiso", "POST", data=request.data,tipo="Seguridad")  # Log de asignación

        print("Permiso asignado correctamente")
        return Response({"message": "Permiso asignado correctamente."}, status=200)

    @eliminar_permiso_schema
    @action(detail=False, methods=['post'], url_path="eliminar-permiso")
    def eliminar_permiso(self, request):
        print("Inicio de eliminar_permiso")
        check_user_permissions(request.user, ['Users'])

        rol_id = request.data.get('rol_id')
        permiso_id = request.data.get('permiso_id')

        print(f"Datos recibidos - rol_id: {rol_id}, permiso_id: {permiso_id}")

        if not rol_id or not permiso_id:
            print("Error: Falta rol_id o permiso_id")
            return Response({"error": "Los campos 'rol_id' y 'permiso_id' son obligatorios."}, status=400)

        rol = Rol.objects.filter(id=rol_id).first()
        permiso = Permiso.objects.filter(id=permiso_id).first()

        print(f"Objeto rol encontrado: {rol}, Objeto permiso encontrado: {permiso}")

        if not rol:
            print(f"Error: Rol con id {rol_id} no encontrado")
            return Response({"error": f"Rol con id {rol_id} no encontrado."}, status=400)
        if not permiso:
            print(f"Error: Permiso con id {permiso_id} no encontrado")
            return Response({"error": f"Permiso con id {permiso_id} no encontrado."}, status=400)

        # Obtener el rol del usuario correctamente
        user_rol = UserRol.objects.filter(user=request.user).first()
        print(f"Rol del usuario autenticado: {user_rol}")

        if user_rol and user_rol.rol.id == rol.id:
            return Response({"error": "No puedes eliminar permisos de tu propio rol."}, status=400)

        deleted_count, _ = RolPermiso.objects.filter(rol=rol, permiso=permiso).delete()
        print(f"Cantidad de permisos eliminados: {deleted_count}")

        if deleted_count == 0:
            print("Error: El permiso no estaba asignado a este rol")
            return Response({"error": "El permiso no estaba asignado a este rol."}, status=400)

        makelog(request.user, "roles/eliminar-permiso", "POST", data=request.data,tipo="Seguridad")

        print("Permiso eliminado correctamente")
        return Response({"message": "Permiso eliminado correctamente."}, status=200)



    ###ROLES CON PERMISOS
    @obtener_roles_con_permisos_schema
    @action(detail=False, methods=['get'], url_path="roles-con-permisos")
    def obtener_roles_con_permisos(self, request):
        # Verificar permisos
        check_user_permissions(request.user, ['Users'])
        roles_con_permisos = Rol.objects.prefetch_related('rol_permisos__permiso').filter(
            rol_permisos__isnull=False
        ).distinct()

        data = [
            {
                "id": rol.id,
                "name": rol.name,
                "permisos": [
                    {
                        "id": permiso.id,
                        "name": permiso.name,
                        "description": permiso.description
                    }
                    for permiso in rol.permisos.all()
                ],
            }
            for rol in roles_con_permisos
        ]
        makelog(request.user, "roles/roles-con-permisos", "GET")  # Log de consulta
        return Response(data)

    @obtener_roles_sin_permisos_schema
    @action(detail=False, methods=['get'], url_path="roles-sin-permisos")
    def obtener_roles_sin_permisos(self, request):
        # Verificar permisos
        check_user_permissions(request.user, ['Users'])
        roles_sin_permisos = Rol.objects.filter(rol_permisos__isnull=True).distinct()

        data = [
            {
                "id": rol.id,
                "name": rol.name,
            }
            for rol in roles_sin_permisos
        ]
        makelog(request.user, "roles/roles-sin-permisos", "GET")  # Log de consulta
        return Response(data)
