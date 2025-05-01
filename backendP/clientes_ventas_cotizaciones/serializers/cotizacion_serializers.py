from rest_framework import serializers
from clientes_ventas_cotizaciones.models import Cotizacion


class CotizacionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cotizacion
        fields = [
            "id",
            "pieza",
            "precio",
            "fecha_cotizacion",
            "total_estimado",
            "detalles",
            "corte_plegado",
            "plancha",
            "venta"
        ]
        read_only_fields = ["fecha_cotizacion"]
