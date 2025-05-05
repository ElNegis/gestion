from django.contrib import admin
from django.urls import path, include
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView, SpectacularRedocView

from app.views.health_check_view import HealthCheckView
from app.views.refresh_token import CustomTokenRefreshView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/cotizador/', include('cotizador.urls')),
    path('api/users/', include('users.urls')),
    path('api/roles_permisos/', include('roles_permisos.urls')),  # Rutas de roles_permisos
    path('api/clientes_ventas_cotizaciones/', include('clientes_ventas_cotizaciones.urls')),  # Nueva app
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/swagger/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    path('api/docs/redoc/', SpectacularRedocView.as_view(url_name='schema'), name='redoc'),
    path('api/health/', HealthCheckView.as_view(), name='health-check'),
    # …path('api/auth/refresh/', CustomTokenRefreshView.as_view(), name='token-refresh'),
]
