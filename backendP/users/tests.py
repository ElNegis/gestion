# app/tests/test_health_check.py
from django.test import TestCase
from rest_framework.test import APIClient

class HealthCheckTest(TestCase):
    """
    A test case for the health check endpoint.
    """
    def setUp(self):
        # Initialize the DRF test client
        self.client = APIClient()

    def test_health_endpoint_returns_ok(self):
        """
        GET /api/health/ should return HTTP 200 and JSON {"status": "OK"} without authentication.
        """
        response = self.client.get('/api/health/')
        # Verify status code
        self.assertEqual(response.status_code, 200)
        # Verify response body
        self.assertEqual(response.json(), {"status": "OK"})

    def test_health_endpoint_no_auth_required(self):
        """
        Ensure that the health endpoint does not require authentication.
        """
        # Do not set any credentials, just call the endpoint
        response = self.client.get('/api/health/')
        self.assertFalse('Authorization' in response.request)
        self.assertEqual(response.status_code, 200)
