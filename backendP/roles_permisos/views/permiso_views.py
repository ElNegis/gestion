from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from drf_spectacular.utils import extend_schema_view
from users.utils import check_user_permissions, makelog  # Importar makelog
from ..models import Permiso
from ..serializers import PermisoSerializer
from ..schemas import list_permisos_schema, get_permiso_schema

@extend_schema_view(
    list=list_permisos_schema,
    retrieve=get_permiso_schema
)
class PermisoViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet para manejar permisos.
    """
    permission_classes = [IsAuthenticated]
    queryset = Permiso.objects.all()
    serializer_class = PermisoSerializer

    def list(self, request, *args, **kwargs):

        check_user_permissions(request.user, ['Users'])

        makelog(request.user, "permisos/list", "GET")
        return super().list(request, *args, **kwargs)

    def retrieve(self, request, *args, **kwargs):

        check_user_permissions(request.user, ['User'])


        permiso_id = kwargs.get('pk')
        makelog(request.user, f"permisos/{permiso_id}/detail", "GET", object_id=permiso_id)
        return super().retrieve(request, *args, **kwargs)
