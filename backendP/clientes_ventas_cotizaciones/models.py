import datetime
from django.contrib.auth import get_user_model
from django.db import models
from django.utils.timezone import now

from cotizador.models import CortePlegado, Plancha
User = get_user_model()

class Cliente(models.Model):
    ci = models.CharField(max_length=250, default='-', null=False)
    email = models.EmailField(max_length=250, blank=True, null=True)  # Email ahora es opcional
    telefono = models.CharField(max_length=250, default='-', null=False)
    nombre = models.CharField(max_length=255)
    apellido = models.CharField(max_length=255)
    direccion = models.TextField(null=True, blank=True)
    codigo_clien = models.CharField(max_length=20, unique=True, blank=True)
    creado_en = models.DateTimeField(default=now)

    class Meta:
        verbose_name = "Cliente"
        verbose_name_plural = "Clientes"
        db_table = "clientes"

    def save(self, *args, **kwargs):
        # Importación diferida para evitar circular imports
        from .utils.codigo_cliente_utils import generar_codigo_cliente

        # Generar el código único si no existe
        if not self.codigo_clien:
            self.codigo_clien = generar_codigo_cliente(self.nombre, self.apellido)
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.nombre} {self.apellido}"


class Venta(models.Model):
    cliente = models.ForeignKey(
        Cliente, on_delete=models.CASCADE, related_name="ventas"
    )
    usuario = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="ventas"
    )
    fecha_venta = models.DateField(default=datetime.date.today)  # Correcto uso de datetime.date.today
    total = models.DecimalField(max_digits=10, decimal_places=2, null=False)

    class Meta:
        verbose_name = "Venta"
        verbose_name_plural = "Ventas"
        db_table = "ventas"

    def __str__(self):
        return f"Venta #{self.id} - Cliente: {self.cliente} - Usuario: {self.usuario.username}"





class Cotizacion(models.Model):
    pieza = models.CharField(max_length=250, default="-", null=False)
    precio = models.DecimalField(max_digits=10, decimal_places=2, null=False)
    fecha_cotizacion = models.DateField(default=datetime.date.today, null=False)  # Corregido a DateField
    plancha = models.ForeignKey(
        Plancha, on_delete=models.CASCADE, related_name="cotizaciones"
    )
    corte_plegado = models.ForeignKey(
        CortePlegado, on_delete=models.CASCADE, related_name="cotizaciones"
    )
    venta = models.ForeignKey(
        Venta, on_delete=models.CASCADE, related_name="cotizaciones"
    )
    total_estimado = models.DecimalField(max_digits=10, decimal_places=2)
    detalles = models.TextField()

    class Meta:
        verbose_name = "Cotización"
        verbose_name_plural = "Cotizaciones"
        db_table = "cotizaciones"

    def __str__(self):
        return f"Cotización #{self.id} - Cliente: {self.venta.cliente}"
