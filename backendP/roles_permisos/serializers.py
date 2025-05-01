from rest_framework import serializers
from .models import Permiso, Rol, RolPermiso

class PermisoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Permiso
        fields = ['id', 'name', 'description']

class RolSerializer(serializers.ModelSerializer):
    class Meta:
        model = Rol
        fields = ['id', 'name', 'description']

class RolPermisoSerializer(serializers.ModelSerializer):
    permiso = PermisoSerializer()
    rol = RolSerializer()

    class Meta:
        model = RolPermiso
        fields = ['id', 'permiso', 'rol']
