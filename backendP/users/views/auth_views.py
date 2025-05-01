from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from django.core.cache import cache  # Para almacenamiento en caché (bloqueo temporal)
from drf_spectacular.utils import extend_schema_view
from ..schemas import login_schema, logout_schema
from ..serializers.auth_serializers import UserLoginSerializer, UserLogoutSerializer
import datetime

from ..utils import makelog


@extend_schema_view(
    post=login_schema
)
class LoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        username = request.data.get("username")
        if not username:
            return Response({"error": "El campo 'username' es obligatorio."}, status=400)

        # Verificar si el usuario está bloqueado
        cache_key = f"login_attempts_{username}"
        attempts_data = cache.get(cache_key)
        if attempts_data and attempts_data.get("locked_until") and attempts_data["locked_until"] > datetime.datetime.now():
            return Response(
                {"error": f"Demasiados intentos fallidos. Intente nuevamente después de {attempts_data['locked_until'] - datetime.datetime.now()} minutos."},
                status=403
            )

        serializer = UserLoginSerializer(data=request.data)
        if serializer.is_valid():
            cache.delete(cache_key)
            return Response(serializer.data)

        # Incrementar intentos fallidos
        if not attempts_data:
            attempts_data = {"attempts": 0, "locked_until": None}

        attempts_data["attempts"] += 1
        # Intentos fallidos mayor a 3 bloqueo de cuenta
        if attempts_data["attempts"] >= 3:
            attempts_data["locked_until"] = datetime.datetime.now() + datetime.timedelta(minutes=15)
            cache.set(cache_key, attempts_data, timeout=15 * 60)
            return Response(
                {"error": "Demasiados intentos fallidos. Su cuenta ha sido bloqueada temporalmente por 15 minutos."},
                status=403
            )

        cache.set(cache_key, attempts_data, timeout=15 * 60)
        makelog(request.user, "auth/login", "POST", data=request.data,tipo="Seguridad")
        return Response({"error": "Credenciales inválidas. Intente nuevamente."}, status=401)


@extend_schema_view(
    post=logout_schema
)
class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = UserLogoutSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=400)

        serializer.save()
        makelog(request.user, "auth/logout", "POST", tipo="Seguridad")
        return Response({"detail": "Sesión cerrada exitosamente."})
