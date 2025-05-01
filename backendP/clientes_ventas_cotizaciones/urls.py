from django.urls import path, include
from rest_framework.routers import DefaultRouter
from clientes_ventas_cotizaciones.views import ClienteViewSet, VentaViewSet, CotizacionViewSet

# Configuración del router
router = DefaultRouter()
router.register(r'clientes', ClienteViewSet, basename='cliente')
router.register(r'ventas', VentaViewSet, basename='venta')
router.register(r'cotizaciones', CotizacionViewSet, basename='cotizacion')

# URLs personalizadas adicionales si es necesario
urlpatterns = [
    path('', include(router.urls)),
]
