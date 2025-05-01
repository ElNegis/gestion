from drf_spectacular.utils import extend_schema, OpenApiExample
from drf_spectacular.types import OpenApiTypes

def calcular_piezas_schema(func):
    return extend_schema(
        tags=["Cálculo de piezas"],
        request={
            "application/json": {
                "type": "object",
                "properties": {
                    "espesor": {"type": "integer", "description": "Espesor de la pieza en mm"},
                    "largo_pieza": {"type": "integer", "description": "Largo de la pieza en mm"},
                    "ancho_pieza": {"type": "integer", "description": "Ancho de la pieza en mm"},
                    "cantidad_golpes": {"type": "integer", "description": "Cantidad de golpes necesarios para la pieza"},
                    "cantidad_piezas": {"type": "integer", "description": "Cantidad de piezas a producir"}
                },
                "required": ["espesor", "largo_pieza", "ancho_pieza", "cantidad_golpes", "cantidad_piezas"]
            }
        },
        responses={
            200: OpenApiTypes.OBJECT,
            400: {"type": "object", "properties": {"error": {"type": "string"}}},
            404: {"type": "object", "properties": {"error": {"type": "string"}}},
        },
        examples=[
            OpenApiExample(
                "Ejemplo de solicitud exitosa",
                value={
                    "espesor": 4,
                    "largo_pieza": 3000,
                    "ancho_pieza": 200,
                    "cantidad_golpes": 3,
                    "cantidad_piezas": 50
                },
                request_only=True
            ),
            OpenApiExample(
                "Ejemplo de respuesta exitosa",
                value={
                    "plancha_ideal": {
                        "id": 1,
                        "espesor": 4,
                        "largo": 3000,
                        "ancho": 1200,
                        "precio": 1960,
                        "proveedor": {
                            "id": 1,
                            "nombre": "Proveedor A"
                        }
                    },
                    "Corte Plegado Requerido": {
                        "id": 2,
                        "espesor": 4,
                        "largo": 3000,
                        "precio": 14
                    },
                    "precio_por_unidad": 386.66,
                    "precio_total": 19333.00,
                    "piezas_por_plancha": 6
                },
                response_only=True
            )
        ]
    )(func)
