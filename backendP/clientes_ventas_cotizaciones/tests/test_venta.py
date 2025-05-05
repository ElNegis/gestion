from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework import status
from django.contrib.auth import get_user_model
from unittest.mock import patch
from clientes_ventas_cotizaciones.models import Cliente, Venta

User = get_user_model()

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


class VentaAPITest(APITestCase):
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
        
        # Crear venta de prueba
        self.venta = Venta.objects.create(
            cliente=self.cliente,
            usuario=self.user,
            total=1000.50
        )
        
        # Definir URLs
        self.list_url = reverse('venta-list')
        self.detail_url = reverse('venta-detail', args=[self.venta.id])

    def test_list_ventas(self):
        """Prueba para listar ventas"""
        # Mockear la verificación de permisos para que la prueba pase
        with patch('users.utils.permission_checker.check_user_permissions'):
            response = self.client.get(self.list_url)
            self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_venta(self):
        """Prueba para crear una venta"""
        data = {
            'cliente': self.cliente.id,
            'total': 2000.75
        }
        
        # Mockear la verificación de permisos para que la prueba pase
        with patch('users.utils.permission_checker.check_user_permissions'):
            response = self.client.post(self.list_url, data, format='json')
            self.assertEqual(response.status_code, status.HTTP_201_CREATED)
            self.assertEqual(Venta.objects.count(), 2)
            
    def test_retrieve_venta(self):
        """Prueba para obtener una venta específica"""
        # Mockear la verificación de permisos para que la prueba pase
        with patch('users.utils.permission_checker.check_user_permissions'):
            response = self.client.get(self.detail_url)
            self.assertEqual(response.status_code, status.HTTP_200_OK)
            self.assertEqual(response.data['id'], self.venta.id)