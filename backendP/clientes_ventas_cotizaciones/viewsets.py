# clientes_ventas_cotizaciones/viewsets.py
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from .models import Cliente
from .serializers import ClienteSerializer

class ClienteViewSet(viewsets.ModelViewSet):
    queryset = Cliente.objects.all()
    serializer_class = ClienteSerializer

    # Permito a cualquiera (incluso anónimo) hacer POST/GET/etc
    permission_classes = [IsAuthenticatedOrReadOnly]
