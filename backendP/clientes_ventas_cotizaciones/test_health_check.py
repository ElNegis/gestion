from django.test import TestCase
from django.contrib.auth import get_user_model
from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework import status

from .models import Cliente, Venta, Cotizacion
from cotizador.models import Plancha, CortePlegado

User = get_user_model()

class ClienteModelTest(TestCase):
    def setUp(self):
        self.cliente = Cliente.objects.create(
            nombre="Juan",
            apellido="Pérez",
            email="juan@example.com",
            telefono="555-1234"
        )

    def test_codigo_cliente_generado(self):
        """Verifica que el código de cliente se genera automáticamente"""
        self.assertIsNotNone(self.cliente.codigo_clien)
        self.assertTrue(len(self.cliente.codigo_clien) > 0)

    def test_str_representation(self):
        """Verifica la representación en string del cliente"""
        self.assertEqual(str(self.cliente), "Juan Pérez")

class VentaModelTest(TestCase):
    def setUp(self):
        # Crear usuario para la prueba
        self.user = User.objects.create_user(
            username="testuser",
            password="testpass123"
        )
        
        # Crear cliente para la prueba
        self.cliente = Cliente.objects.create(
            nombre="Juan",
            apellido="Pérez",
            email="juan@example.com",
            telefono="555-1234"
        )
        
        # Crear venta
        self.venta = Venta.objects.create(
            cliente=self.cliente,
            usuario=self.user,
            total=1000.50
        )

    def test_venta_creation(self):
        """Verifica que la venta se crea correctamente"""
        self.assertEqual(self.venta.cliente, self.cliente)
        self.assertEqual(self.venta.usuario, self.user)
        self.assertEqual(float(self.venta.total), 1000.50)

    def test_str_representation(self):
        """Verifica la representación en string de la venta"""
        expected = f"Venta #{self.venta.id} - Cliente: {self.cliente} - Usuario: {self.user.username}"
        self.assertEqual(str(self.venta), expected)

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
            apellido="Pérez",
            email="juan@example.com",
            telefono="555-1234"
        )

    def test_list_clientes(self):
        """Prueba para listar clientes"""
        url = reverse('cliente-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_cliente(self):
        """Prueba para crear un cliente"""
        url = reverse('cliente-list')
        data = {
            'nombre': 'María',
            'apellido': 'González',
            'email': 'maria@example.com',
            'telefono': '555-5678'
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
