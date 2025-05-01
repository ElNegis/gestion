from rest_framework import serializers
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import AccessToken, RefreshToken, TokenError


class UserLoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField(write_only=True)
    access_token = serializers.SerializerMethodField()
    refresh_token = serializers.SerializerMethodField()

    def validate(self, data):
        username = data.get('username')
        password = data.get('password')
        user = authenticate(username=username, password=password)
        if not user:
            raise serializers.ValidationError('Credenciales inválidas.')
        data['user'] = user
        return data

    def get_access_token(self, obj):
        user = obj['user']
        return str(AccessToken.for_user(user))

    def get_refresh_token(self, obj):
        user = obj['user']
        return str(RefreshToken.for_user(user))

    def to_representation(self, instance):
        return {
            'access_token': self.get_access_token(instance),
            'refresh_token': self.get_refresh_token(instance),
            'username': instance['user'].username
        }


class UserLogoutSerializer(serializers.Serializer):
    refresh_token = serializers.CharField()

    def validate(self, data):
        refresh_token = data.get('refresh_token')
        if not refresh_token:
            raise serializers.ValidationError("El token de actualización es obligatorio.")
        return data

    def save(self, **kwargs):
        refresh_token = self.validated_data['refresh_token']
        try:
            token = RefreshToken(refresh_token)
            token.blacklist()  # Revoca el token de actualización
        except TokenError as e:
            raise serializers.ValidationError(f"Error al revocar el token: {str(e)}")
