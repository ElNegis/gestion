from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.exceptions import ValidationError, PermissionDenied
from drf_spectacular.utils import extend_schema_view
from users.utils.services_rol import assign_role_to_user, remove_role_from_user
from ..schemas import assign_role_schema, remove_role_schema
from ..utils import check_user_permissions
from ..utils.log_util import makelog


@extend_schema_view(
    post=assign_role_schema
)
class AssignRoleView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Users'])
        user_id = request.data.get("user_id")
        role_id = request.data.get("role_id")

        if not user_id or not role_id:
            raise ValidationError({"error": "Los campos 'user_id' y 'role_id' son obligatorios."})

        if request.user.id == int(user_id):
            raise PermissionDenied({"error": "No puedes asignarte un nuevo rol a ti mismo."})

        try:
            result = assign_role_to_user(user_id, role_id, request.user)
            makelog(request.user, "roles/assign", "POST", data=request.data,tipo="Seguridad")
            return Response(result)
        except (ValueError, PermissionDenied) as e:
            return Response({"error": str(e)}, status=403 if isinstance(e, PermissionDenied) else 400)



@extend_schema_view(
    post=remove_role_schema
)
class RemoveRoleView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Users'])
        user_id = request.data.get("user_id")
        role_id = request.data.get("role_id")

        if not user_id or not role_id:
            raise ValidationError({"error": "Los campos 'user_id' y 'role_id' son obligatorios."})

        if request.user.id == int(user_id):
            raise PermissionDenied({"error": "No puedes eliminar tu propio rol."})

        try:
            result = remove_role_from_user(user_id, role_id, request.user)
            makelog(request.user, "roles/remove", "POST", tipo="Seguridad",data=request.data)
            return Response(result)
        except (ValueError, PermissionDenied) as e:
            return Response({"error": str(e)}, status=403 if isinstance(e, PermissionDenied) else 400)

