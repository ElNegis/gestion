from django.db import models



class Proveedor(models.Model):
    nombre= models.TextField(max_length=240)

    def __str__(self):
        return f"Proveedores{self.id}: {self.nombre}"

class CortePlegado(models.Model):
    espesor= models.FloatField()
    largo = models.FloatField()
    precio = models.FloatField(default=0)

    def __str__(self):
        return f"Plegado{self.id}: {self.espesor}mm {self.precio}"


class Plancha(models.Model):
    espesor = models.FloatField()
    largo = models.FloatField()
    ancho = models.FloatField()

    def __str__(self):
        return f"Plancha {self.id}: {self.espesor}mm {self.largo} x {self.ancho}"


class PlanchaProveedor(models.Model):
    precio = models.FloatField()
    proveedor = models.ForeignKey(Proveedor, on_delete=models.CASCADE)
    plancha = models.ForeignKey(Plancha, on_delete=models.CASCADE)

    def __str__(self):
        return f"PlanchaProveedor {self.plancha.id} - Proveedor {self.proveedor.id}"

class Cotizacion(models.Model):
    fecha_cotizacion = models.DateField()
    plancha = models.ForeignKey(Plancha, on_delete=models.CASCADE)
    corte_plegado = models.ForeignKey(CortePlegado, on_delete=models.CASCADE)

    #usario

    def __str__(self):
        return f"Cotizacion: {self.id}.  {self.fecha_cotizacion}"


