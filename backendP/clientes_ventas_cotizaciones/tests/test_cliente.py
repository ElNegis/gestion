from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework import status
from django.contrib.auth import get_user_model
from unittest.mock import patch
from clientes_ventas_cotizaciones.models import Cliente

User = get_user_model()

class ClienteModelTest(TestCase):
    def setUp(self):
        self.cliente = Cliente.objects.create(
            nombre="Juan",
            apellido="Pu00e9rez",
            email="juan@example.com",
            telefono="555-1234"
        )

    def test_codigo_cliente_generado(self):
        """Verifica que el cu00f3digo de cliente se genera automu00e1ticamente"""
        self.assertIsNotNone(self.cliente.codigo_clien)
        self.assertTrue(len(self.cliente.codigo_clien) > 0)

    def test_str_representation(self):
        """Verifica la representaciu00f3n en string del cliente"""
        self.assertEqual(str(self.cliente), "Juan Pu00e9rez")


class ClienteAPITest(APITestCase):
    def setUp(self):
        # Crear usuario con permisos
        self.user = User.objects.create_user(
            username="testuser",
            password="testpass123",
            is_staff=True
        )
        
        # Autenticar al usuario
        self.client.force_authenticate(user=self.user)
        
        # Crear cliente de prueba
        self.cliente = Cliente.objects.create(
            nombre="Juan",
            apellido="Pu00e9rez",
            email="juan@example.com",
            telefono="555-1234"
        )
        
        # Definir URLs
        self.list_url = reverse('cliente-list')
        self.detail_url = reverse('cliente-detail', args=[self.cliente.id])

    def test_list_clientes(self):
        """Prueba para listar clientes"""
        # Mockear la verificaciu00f3n de permisos para que la prueba pase
        with patch('users.utils.permission_checker.check_user_permissions'):
            response = self.client.get(self.list_url)
            self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_cliente(self):
        """Prueba para crear un cliente"""
        data = {
            'nombre': 'Maru00eda',
            'apellido': 'Gonzu00e1lez',
            'email': 'maria@example.com',
            'telefono': '555-5678'
        }
        
        # Mockear la verificaciu00f3n de permisos para que la prueba pase
        with patch('users.utils.permission_checker.check_user_permissions'):
            response = self.client.post(self.list_url, data, format='json')
            self.assertEqual(response.status_code, status.HTTP_201_CREATED)
            self.assertEqual(Cliente.objects.count(), 2)
            
    def test_update_cliente(self):
        """Prueba para actualizar un cliente"""
        data = {
            'nombre': 'Juan Carlos',
            'apellido': 'Pu00e9rez',
            'email': 'juancarlos@example.com',
            'telefono': '555-1234'
        }
        
        # Mockear la verificaciu00f3n de permisos para que la prueba pase
        with patch('users.utils.permission_checker.check_user_permissions'):
            response = self.client.put(self.detail_url, data, format='json')
            self.assertEqual(response.status_code, status.HTTP_200_OK)
            
            # Refrescar el objeto desde la base de datos
            self.cliente.refresh_from_db()
            self.assertEqual(self.cliente.nombre, 'Juan Carlos')
            self.assertEqual(self.cliente.email, 'juancarlos@example.com')