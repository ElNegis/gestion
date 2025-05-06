from rest_framework import viewsets, permissions, status
from rest_framework.response import Response
from rest_framework.decorators import action
from .models import MiModelo
from .serializers import MiModeloSerializer

class MiModeloViewSet(viewsets.ModelViewSet):
    """
    API endpoint para gestionar MiModelo.
    """
    queryset = MiModelo.objects.all()
    serializer_class = MiModeloSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    @action(detail=False, methods=['get'])
    def activos(self, request):
        """
        Retorna solo los modelos activos
        """
        activos = MiModelo.objects.filter(activo=True)
        serializer = self.get_serializer(activos, many=True)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def desactivar(self, request, pk=None):
        """
        Desactiva un modelo específico
        """
        modelo = self.get_object()
        modelo.activo = False
        modelo.save()
        return Response({'status': 'modelo desactivado'}, status=status.HTTP_200_OK)