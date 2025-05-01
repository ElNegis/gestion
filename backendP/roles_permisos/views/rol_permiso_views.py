from rest_framework.decorators import api_view, permission_classes
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.exceptions import NotFound
from drf_spectacular.utils import extend_schema_view
from ..models import Rol, Permiso
from ..schemas import obtener_permisos, obtener_permisos_user
from users.utils import makelog  # Importar makelog
from users.utils.permission_checker import check_user_permissions


@extend_schema_view(
    get=obtener_permisos,
)
class ObtenerPermisosDeRolView(APIView):
    """
    Endpoint para obtener los permisos asignados a un rol.
    """
    permission_classes = [IsAuthenticated]

    def get(self, request, rol_id, *args, **kwargs):
        # Verificar permisos
        check_user_permissions(request.user, ['Users'])

        try:
            rol = Rol.objects.prefetch_related('permisos').get(id=rol_id)
        except Rol.DoesNotExist:
            raise NotFound({"detail": f"Rol con id {rol_id} no encontrado."})

        permisos = rol.permisos.all()
        permisos_data = [
            {"id": permiso.id, "name": permiso.name, "description": permiso.description}
            for permiso in permisos
        ]

        makelog(request.user, f"roles/{rol_id}/permissions", "GET")  # Log del acceso al rol
        return Response({"rol": rol.name, "permisos": permisos_data})


@extend_schema_view(get=obtener_permisos_user)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_permissions(request):
    """
    Endpoint para obtener los permisos de un usuario autenticado.
    """
    permisos = Permiso.objects.filter(
        roles__rol_users__user=request.user
    ).distinct()

    permisos_data = [{"id": p.id, "name": p.name, "description": p.description} for p in permisos]

    makelog(request.user, "users/permissions", "GET")  # Log del acceso a los permisos del usuario
    return Response({
        "user": request.user.username,
        "permissions": permisos_data
    })


