from django.contrib.auth.hashers import check_password
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError
from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from ..utils.log_util import makelog
from users.models import User, PasswordHistory
from users.serializers import UserRegisterSerializer, UserUpdateSerializer
from ..utils.permission_checker import check_user_permissions
from drf_spectacular.utils import extend_schema_view, extend_schema
from ..schemas import (
    user_list_schema, user_create_schema, user_update_schema,
    user_destroy_schema, user_me_schema, get_user_schema,
    obtener_usuarios_sin_roles_schema, usuarios_con_roles_schema
)

@extend_schema_view(
    list=user_list_schema,
    create=user_create_schema,
    update=user_update_schema,
    destroy=user_destroy_schema,
    partial_update=user_update_schema,
    retrieve=get_user_schema,
    me=user_me_schema,
)
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    permission_classes = [IsAuthenticated]


    def get_serializer_class(self):
        if self.action in ['update', 'partial_update']:
            return UserUpdateSerializer
        return UserRegisterSerializer

    def list(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Users'])
        users = self.queryset.values('id', 'username', 'nombre', 'apellido', 'is_active', 'last_login')
        makelog(request.user, "users/list", "GET")
        return Response(list(users))

    def create(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Users'])
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        password = request.data.get("password")
        if password:
            try:
                validate_password(password)
            except ValidationError as e:
                return Response({"error": e.messages}, status=status.HTTP_400_BAD_REQUEST)
        user = serializer.save()
        makelog(request.user, "users/create", "POST", data={
            "id": user.id,
            "username": user.username,
            "nombre": user.nombre,
            "apellido": user.apellido,
            "is_active": user.is_active,
            "created_at": user.created_at,
        },tipo="Seguridad")


        return Response({
            "id": user.id,
            "username": user.username,
            "nombre": user.nombre,
            "apellido": user.apellido,
            "is_active": user.is_active,
            "created_at": user.created_at,
        }, status=201)

    def update(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Users'])
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        new_password = request.data.get("password")

        if new_password:
            try:
                validate_password(new_password)
            except ValidationError as e:
                return Response({"error": e.messages}, status=status.HTTP_400_BAD_REQUEST)
            # Verificar si la nueva contraseña ya ha sido usada
            previous_passwords = PasswordHistory.objects.filter(user=instance)
            for old_password in previous_passwords:
                if check_password(new_password, old_password.password):
                    return Response(
                        {"error": "No puedes usar una contraseña que ya usaste antes."},
                        status=status.HTTP_400_BAD_REQUEST
                    )


            PasswordHistory.objects.create(user=instance, password=instance.password)


            instance.set_password(new_password)

        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        instance.save()  # Guardar la nueva contraseña hasheada en la base de datos

        makelog(request.user, f"users/{instance.id}/update", "PUT", data=request.data,tipo="Seguridad")

        return Response(serializer.data)

    def destroy(self, request, *args, **kwargs):
        check_user_permissions(request.user, ['Users'])
        instance = self.get_object()
        makelog(request.user, f"users/{instance.id}/delete", "DELETE",tipo="Seguridad")
        return super().destroy(request, *args, **kwargs)

    @action(detail=False, methods=["get", "put"], url_path="me")
    def me(self, request, *args, **kwargs):
        user = request.user
        roles = user.user_roles.select_related('rol').all()
        roles_data = [
            {
                "id": role.rol.id,
                "name": role.rol.name,
                "description": role.rol.description,
            }
            for role in roles
        ] if roles.exists() else None

        if request.method == "GET":
            makelog(request.user, "users/me", "GET")
            return Response({
                "id": user.id,
                "username": user.username,
                "nombre": user.nombre,
                "apellido": user.apellido,
                "is_active": user.is_active,
                "last_login": user.last_login,
                "created_at": user.created_at,
                "updated_at": user.updated_at,
                "roles": roles_data,
            })

        if request.method == "PUT":
            serializer = self.get_serializer(request.user, data=request.data, partial=True)
            serializer.is_valid(raise_exception=True)
            serializer.save()
            makelog(request.user, "users/me", "PUT", data=request.data)
            return Response(serializer.data)

    @obtener_usuarios_sin_roles_schema
    @action(detail=False, methods=['get'], url_path="usuarios-sin-roles")
    def obtener_usuarios_sin_roles(self, request):
        check_user_permissions(request.user, ['Users'])
        usuarios_sin_roles = User.objects.filter(user_roles__isnull=True).values(
            'id', 'username', 'nombre', 'apellido'
        )
        makelog(request.user, "users/usuarios-sin-roles", "GET")
        return Response(list(usuarios_sin_roles))

    @usuarios_con_roles_schema
    @action(detail=False, methods=['get'], url_path="usuarios-con-roles")
    def obtener_usuarios_con_roles(self, request):
        check_user_permissions(request.user, ['Users'])
        usuarios_con_roles = User.objects.prefetch_related('user_roles__rol').filter(
            user_roles__isnull=False
        ).distinct()
        data = [
            {
                "id": user.id,
                "username": user.username,
                "nombre": user.nombre,
                "apellido": user.apellido,
                "roles": [
                    {
                        "id": rol.rol.id,
                        "name": rol.rol.name,
                    }
                    for rol in user.user_roles.all()
                ],
            }
            for user in usuarios_con_roles
        ]
        makelog(request.user, "users/usuarios-con-roles", "GET")
        return Response(data)
