from django.urls import path
from . import views
from .views_cotizador import CalcularPiezasAPIView

urlpatterns = [
    path('planchas/', views.PlanchaListCreateAPIView.as_view(), name='Crear Planchas'),
    path('planchas/<int:pk>/', views.PlanchaRetrieveUpdateDestroyAPIView.as_view(), name='Detalles Planchas'),
    path('proveedor/', views.ProveedorListCreateAPIView.as_view(), name='proveedor-list-create'),
    path('proveedor/<int:pk>/', views.ProveedorRetrieveUpdateDestroyAPIView.as_view(), name='proveedor-detail'),

    path('CortePlegado/', views.CortePlegadoListView.as_view(), name='plegado-list-create'),
    path('CortePlegado/<int:pk>/', views.CortePlegadoUpdateDestroyApiView.as_view(), name='plegado-detail'),

    path('calcular-piezas/', CalcularPiezasAPIView.as_view(), name='calcular-piezas'),
]
