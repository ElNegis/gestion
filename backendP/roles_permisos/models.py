from django.db import models

class Permiso(models.Model):
    name = models.CharField(max_length=250)
    description = models.TextField()

    def __str__(self):
        return self.name


class Rol(models.Model):
    name = models.CharField(max_length=250)
    description = models.TextField()

    # Relación Many-to-Many con Permiso usando la tabla intermedia
    permisos = models.ManyToManyField(
        'Permiso',  # Modelo relacionado
        through='RolPermiso',  # Tabla intermedia
        related_name='roles',  # Relación inversa desde Permiso
    )

    def __str__(self):
        return self.name


class RolPermiso(models.Model):
    rol = models.ForeignKey(Rol, on_delete=models.CASCADE, related_name='rol_permisos')
    permiso = models.ForeignKey(Permiso, on_delete=models.CASCADE, related_name='permiso_roles')

    class Meta:
        db_table = 'roles_permisos_rolpermiso'  # Nombre exacto de la tabla en la base de datos
        unique_together = ('rol', 'permiso')

