import datetime

from rest_framework import serializers
from clientes_ventas_cotizaciones.models import Venta

class VentaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Venta
        fields = ['id', 'cliente', 'usuario', 'total', 'fecha_venta']

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        # Convertir fecha_venta a date si es datetime
        if isinstance(instance.fecha_venta, datetime.datetime):
            representation['fecha_venta'] = instance.fecha_venta.date()
        return representation
