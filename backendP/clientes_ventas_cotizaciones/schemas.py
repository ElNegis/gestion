from drf_spectacular.utils import OpenApiResponse, extend_schema

# Schemas para ClienteViewSet
cliente_list_schema = extend_schema(
    tags=["Clientes"],
    operation_id="Listar Clientes",
    summary="Obtiene una lista de clientes",
    description="Devuelve una lista de todos los clientes registrados.",
    responses={
        200: OpenApiResponse(
            description="Lista de clientes obtenida exitosamente.",
            examples=[
                {
                    "id": 1,
                    "nombre": "Pedro",
                    "apellido": "Santos",
                    "email": "pedro@example.com",
                    "telefono": "555-1234",
                    "codigo_clien": "Psa#1"
                }
            ]
        )
    }
)

cliente_create_schema = extend_schema(
    tags=["Clientes"],
    operation_id="Crear Cliente",
    summary="Crea un nuevo cliente",
    description="Registra un nuevo cliente. El campo 'codigo_clien' se genera automáticamente y no debe ser proporcionado.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "nombre": {"type": "string", "example": "Pedro"},
                "apellido": {"type": "string", "example": "Santos"},
                "email": {"type": "string", "example": "pedro@example.com", "nullable": True},
                "telefono": {"type": "string", "example": "555-1234"}
            },
            "required": ["nombre", "apellido", "telefono"]
        }
    },
    responses={
        201: {
            "application/json": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "example": 1},
                    "nombre": {"type": "string", "example": "Pedro"},
                    "apellido": {"type": "string", "example": "Santos"},
                    "email": {"type": "string", "example": "pedro@example.com", "nullable": True},
                    "telefono": {"type": "string", "example": "555-1234"},
                    "codigo_clien": {"type": "string", "example": "PSantos#01"}
                }
            }
        }
    }
)

# Schema para actualización de Cliente
cliente_update_schema = extend_schema(
    tags=["Clientes"],
    operation_id="Actualizar Cliente",
    summary="Actualiza un cliente existente",
    description="Actualiza la información de un cliente. El campo 'codigo_clien' no debe ser proporcionado.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "nombre": {"type": "string", "example": "Pedro"},
                "apellido": {"type": "string", "example": "Santos"},
                "email": {"type": "string", "example": "pedro@example.com", "nullable": True},
                "telefono": {"type": "string", "example": "555-1234"}
            },
            "required": ["nombre", "apellido", "telefono"]
        }
    },
    responses={
        200: {
            "application/json": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "example": 1},
                    "nombre": {"type": "string", "example": "Pedro"},
                    "apellido": {"type": "string", "example": "Santos"},
                    "email": {"type": "string", "example": "pedro@example.com", "nullable": True},
                    "telefono": {"type": "string", "example": "555-1234"},
                    "codigo_clien": {"type": "string", "example": "PSantos#01"}
                }
            }
        }
    }
)

cliente_destroy_schema = extend_schema(
    tags=["Clientes"],
    operation_id="Eliminar Cliente",
    summary="Elimina un cliente",
    description="Elimina un cliente específico por su ID.",
    responses={204: OpenApiResponse(description="Cliente eliminado exitosamente.")}
)

cliente_generar_codigo_schema = extend_schema(
    tags=["Clientes"],
    operation_id="Generar Código de Cliente",
    summary="Genera un código único para un cliente",
    description="Genera un código basado en el nombre y apellido del cliente.",
    responses={
        200: OpenApiResponse(
            description="Código generado exitosamente.",
            examples={"codigo": "Psa#1"}
        )
    }
)

# Schemas para VentaViewSet
venta_list_schema = extend_schema(
    tags=["Ventas"],
    operation_id="Listar Ventas",
    summary="Obtiene una lista de ventas",
    description="Devuelve una lista de todas las ventas registradas, incluyendo información del cliente y el usuario que registró la venta.",
    responses={
        200: {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "example": 1},
                    "cliente__nombre": {"type": "string", "example": "Pedro"},
                    "cliente__apellido": {"type": "string", "example": "Santos"},
                    "total": {"type": "number", "example": 5000.50},
                    "fecha_venta": {"type": "string", "example": "2025-01-26T15:00:00Z"},
                    "usuario__username": {"type": "string", "example": "admin"}
                }
            }
        }
    }
)

venta_create_schema = extend_schema(
    tags=["Ventas"],
    operation_id="Crear Venta",
    summary="Crea una nueva venta",
    description="Registra una nueva venta. El usuario en sesión será automáticamente asociado a la venta.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "cliente": {"type": "integer", "example": 1},
                "total": {"type": "number", "example": 5000.50}
            },
            "required": ["cliente", "total"]
        }
    },
    responses={
        201: {
            "type": "object",
            "properties": {
                "id": {"type": "integer", "example": 1},
                "cliente": {"type": "integer", "example": 1},
                "total": {"type": "number", "example": 5000.50},
                "fecha_venta": {"type": "string", "example": "2025-01-26T15:00:00Z"},
                "usuario": {"type": "integer", "example": 1}
            }
        }
    }
)


# Schemas para CotizacionViewSet
cotizacion_list_schema = extend_schema(
    tags=["Cotizaciones"],
    operation_id="Listar Cotizaciones",
    summary="Obtiene una lista detallada de cotizaciones",
    description=(
        "Devuelve una lista de cotizaciones con detalles relacionados de "
        "la plancha y el corte plegado."
    ),
    responses={
        200: {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "example": 1},
                    "pieza": {"type": "string", "example": "Pieza A"},
                    "precio": {"type": "number", "example": 1200.50},
                    "fecha_cotizacion": {"type": "string", "example": "2025-01-26"},
                    "total_estimado": {"type": "number", "example": 3000.75},
                    "detalles": {"type": "string", "example": "Detalles de la cotización"},
                    "corte_plegado": {
                        "type": "object",
                        "properties": {
                            "espesor": {"type": "number", "example": 1.5},
                            "largo": {"type": "number", "example": 200.0},
                            "precio": {"type": "number", "example": 300.0}
                        }
                    },
                    "plancha": {
                        "type": "object",
                        "properties": {
                            "espesor": {"type": "number", "example": 0.8},
                            "largo": {"type": "number", "example": 2500.0},
                            "ancho": {"type": "number", "example": 1250.0}
                        }
                    },
                    "venta_total": {"type": "number", "example": 5000.0}
                }
            }
        }
    }
)

cotizacion_create_schema = extend_schema(
    tags=["Cotizaciones"],
    operation_id="Crear Cotización",
    summary="Crea una nueva cotización",
    description="Registra una nueva cotización. El campo fecha_cotizacion se genera automáticamente.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "pieza": {"type": "string", "example": "Pieza A"},
                "precio": {"type": "number", "example": 500.75},
                "total_estimado": {"type": "number", "example": 1500.50},
                "detalles": {"type": "string", "example": "Detalles de la cotización"},
                "corte_plegado": {"type": "integer", "example": 1},
                "plancha": {"type": "integer", "example": 2},
                "venta": {"type": "integer", "example": 3}
            },
            "required": ["pieza", "precio", "total_estimado", "corte_plegado_id", "plancha_id", "venta_id"]
        }
    },
    responses={
        201: {
            "type": "object",
            "properties": {
                "id": {"type": "integer", "example": 1},
                "pieza": {"type": "string", "example": "Pieza A"},
                "precio": {"type": "number", "example": 500.75},
                "fecha_cotizacion": {"type": "string", "example": "2025-01-26T10:00:00Z"},
                "total_estimado": {"type": "number", "example": 1500.50},
                "detalles": {"type": "string", "example": "Detalles de la cotización"}
            }
        }
    }
)
