from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager
from django.db import models
from django.utils.timezone import now
from django.core.exceptions import ValidationError


class CustomUserManager(BaseUserManager):
    def create_user(self, username, password=None, **extra_fields):
        if not username:
            raise ValueError("El nombre de usuario es obligatorio.")
        # Ignorar campos no necesarios como 'email'
        extra_fields.pop('email', None)  # Ignorar email si aparece
        user = self.model(username=username, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, password=None, **extra_fields):
        """
        Crea y guarda un superusuario con los campos adicionales definidos.
        """
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_staff', True)

        if not extra_fields.get('is_superuser'):
            raise ValueError("El superusuario debe tener is_superuser=True.")
        if not extra_fields.get('is_staff'):
            raise ValueError("El superusuario debe tener is_staff=True.")

        return self.create_user(username=username, password=password, **extra_fields)




class User(AbstractBaseUser, PermissionsMixin):
    # Campos personalizados según tu diseño
    username = models.CharField(max_length=250, unique=True, verbose_name="Nombre de Usuario")
    password = models.CharField(max_length=250)
    nombre = models.CharField(max_length=250, default='-', verbose_name="Nombre")
    apellido = models.CharField(max_length=250, default='-', verbose_name="Apellido")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Fecha de Creación")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Fecha de Actualización")


    # Campos heredados necesarios de AbstractBaseUser y PermissionsMixin
    is_active = models.BooleanField(default=True, verbose_name="Está Activo")
    is_staff = models.BooleanField(default=False, verbose_name="Es Staff")
    is_superuser = models.BooleanField(default=False, verbose_name="Es Superusuario")
    last_login = models.DateTimeField(null=True, blank=True, verbose_name="Último Inicio de Sesión")

    objects = CustomUserManager()

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = []

    def set_password(self, raw_password):
        if self.password:
            if PasswordHistory.objects.filter(user=self).exists():
                previous_passwords = PasswordHistory.objects.filter(user=self)
                for old_password in previous_passwords:
                    if check_password(raw_password, old_password.password):
                        raise ValueError("No puedes usar una contraseña que ya usaste antes")


            PasswordHistory.objects.create(user=self, password=self.password)

        super().set_password(raw_password)

    def __str__(self):
        return self.username



class UserRol(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="user_roles")
    rol = models.ForeignKey('roles_permisos.Rol', on_delete=models.CASCADE, related_name="rol_users")

    class Meta:
        unique_together = ('user', 'rol')
        verbose_name = "Relación Usuario-Rol"
        verbose_name_plural = "Relaciones Usuario-Rol"
        db_table = "users_userrol"  # Nombre exacto de la tabla en la base de datos

    def __str__(self):
        return f"{self.user.username} - {self.rol.name}"

class Logs(models.Model):
    TIPOS_LOG = [
        ('aplicativo', 'Aplicativo'),
        ('seguridad', 'Seguridad'),
    ]

    id = models.AutoField(primary_key=True)
    log = models.TextField()
    fecha_hora = models.DateTimeField(default=now)
    tipo = models.CharField(max_length=200, choices=TIPOS_LOG)

    class Meta:
        verbose_name = "Log"
        verbose_name_plural = "Logs"
        db_table = "logs"

    def __str__(self):
        return f"Log {self.tipo.capitalize()} #{self.id} - {self.fecha_hora}"


class PasswordHistory(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="password_histories")
    password = models.CharField(max_length=250)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = "Historial de Contraseña"
        verbose_name_plural = "Historial de Contraseñas"

    def __str__(self):
        return f"Historial de {self.user.username} - {self.created_at}"