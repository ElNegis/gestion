from rest_framework import serializers
from .models import MiModelo

class MiModeloSerializer(serializers.ModelSerializer):
    class Meta:
        model = MiModelo
        fields = ['id', 'nombre', 'descripcion', 'fecha_creacion', 'activo']
        read_only_fields = ['id', 'fecha_creacion']