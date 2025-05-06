from django.db import models

# Ejemplo de modelo para tu microservicio
class MiModelo(models.Model):
    nombre = models.CharField(max_length=100)
    descripcion = models.TextField(blank=True, null=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    activo = models.BooleanField(default=True)
    
    def __str__(self):
        return self.nombre
    
    class Meta:
        verbose_name = 'Mi Modelo'
        verbose_name_plural = 'Mis Modelos'