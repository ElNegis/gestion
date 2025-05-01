from rest_framework import serializers
from .models import Plancha, Proveedor, PlanchaProveedor, CortePlegado
from drf_spectacular.utils import extend_schema_field, OpenApiTypes


class ProveedorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Proveedor
        fields = '__all__'


class CortePlegadoSerializer(serializers.ModelSerializer):
    class Meta:
        model = CortePlegado
        fields = '__all__'


class PlanchaSerializer(serializers.ModelSerializer):
    # Campos de solo lectura (usados en las respuestas)
    precio = serializers.SerializerMethodField(read_only=True)
    proveedor = serializers.SerializerMethodField(read_only=True)

    # Campos de escritura (usados en las solicitudes)
    proveedor_id = serializers.PrimaryKeyRelatedField(
        queryset=Proveedor.objects.all(),
        write_only=True,
        source="proveedor"
    )
    precio_valor = serializers.FloatField(write_only=True)

    class Meta:
        model = Plancha
        fields = ['id', 'espesor', 'largo', 'ancho', 'precio', 'proveedor', 'proveedor_id', 'precio_valor']

    def create(self, validated_data):
        """
        Personaliza el proceso de creación para manejar la relación con PlanchaProveedor.
        """
        # Extraer campos de proveedor y precio del validated_data
        proveedor = validated_data.pop("proveedor")
        precio_valor = validated_data.pop("precio_valor")

        # Crear la instancia de Plancha
        plancha = Plancha.objects.create(**validated_data)

        # Crear la relación en la tabla PlanchaProveedor
        PlanchaProveedor.objects.create(plancha=plancha, proveedor=proveedor, precio=precio_valor)

        return plancha

    def update(self, instance, validated_data):
        """
        Actualiza la relación entre Plancha y PlanchaProveedor.
        """
        # Extraer campos relacionados
        proveedor = validated_data.pop("proveedor", None)
        precio_valor = validated_data.pop("precio_valor", None)

        # Actualizar los campos de la instancia de Plancha
        instance.espesor = validated_data.get("espesor", instance.espesor)
        instance.largo = validated_data.get("largo", instance.largo)
        instance.ancho = validated_data.get("ancho", instance.ancho)
        instance.save()

        # Actualizar la relación PlanchaProveedor si los datos están presentes
        if proveedor and precio_valor is not None:
            plancha_proveedor = PlanchaProveedor.objects.filter(plancha=instance).first()
            if plancha_proveedor:
                plancha_proveedor.proveedor = proveedor
                plancha_proveedor.precio = precio_valor
                plancha_proveedor.save()
            else:
                PlanchaProveedor.objects.create(plancha=instance, proveedor=proveedor, precio=precio_valor)

        return instance

    @extend_schema_field(OpenApiTypes.FLOAT)
    def get_precio(self, obj):
        """
        Obtiene el precio desde la tabla PlanchaProveedor.
        Si no hay registro asociado, devuelve None.
        """
        plancha_proveedor = PlanchaProveedor.objects.filter(plancha=obj).first()
        return plancha_proveedor.precio if plancha_proveedor else None

    @extend_schema_field(ProveedorSerializer)
    def get_proveedor(self, obj):
        """
        Obtiene la información del proveedor desde la tabla PlanchaProveedor.
        Si no hay registro asociado, devuelve None.
        """
        plancha_proveedor = PlanchaProveedor.objects.filter(plancha=obj).first()
        if plancha_proveedor and plancha_proveedor.proveedor:
            return ProveedorSerializer(plancha_proveedor.proveedor).data
        return None
