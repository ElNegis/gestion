from rest_framework import serializers
from django.contrib.auth import get_user_model
from rest_framework.exceptions import ValidationError
from ..utils.per_username_generator import generate_username
from ..utils.password_verifier import is_valid_password

User = get_user_model()


class UserRegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'nombre', 'apellido', 'password']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def validate_password(self, value):
        # Validar la contraseña con reglas específicas
        if value and not is_valid_password(value):
            raise ValidationError("La contraseña debe contener al menos una letra, un número y tener un largo de 12 caracteres.")
        return value

    def create(self, validated_data):
        # Crear usuario con el username generado
        username = validated_data.pop('username', None)
        if not username:
            username = generate_username(validated_data['nombre'], validated_data['apellido'])
        user = User.objects.create_user(
            username=username,
            nombre=validated_data['nombre'],
            apellido=validated_data['apellido'],
            password=validated_data['password']
        )
        return user


class UserUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['nombre', 'apellido', 'password']  # Campos permitidos para actualización
        extra_kwargs = {
            'password': {'write_only': True, 'required': False},
            'nombre': {'required': False},
            'apellido': {'required': False},
        }

    def validate_password(self, value):
        # Validar la contraseña con reglas específicas
        if value and not is_valid_password(value):
            raise ValidationError("La contraseña debe contener al menos una letra y un número.")
        return value

    def update(self, instance, validated_data):

        instance.nombre = validated_data.get('nombre', instance.nombre)
        instance.apellido = validated_data.get('apellido', instance.apellido)


        if 'password' in validated_data:
            instance.set_password(validated_data['password'])

        instance.save()
        return instance


class AdminUserRegisterSerializer(UserRegisterSerializer):
    def validate(self, data):

        request_user = self.context['request'].user
        #if not request_user.roles.filter(name="OnlyAdmin").exists():
         #   raise ValidationError("Solo los administradores pueden crear usuarios.")
        return super().validate(data)
