from drf_spectacular.utils import extend_schema, OpenApiExample, OpenApiParameter
from rest_framework import serializers

# ---------------------------------------------------
# LOGIN / LOGOUT SCHEMAS
# ---------------------------------------------------

login_schema = extend_schema(
    tags=["Auth"],
    operation_id="Login",
    summary="Inicia sesión",
    description="Autentica a un usuario y devuelve los tokens de acceso y actualización.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "username": {"type": "string", "example": "jdoe"},
                "password": {"type": "string", "example": "securepassword123"}
            },
            "required": ["username", "password"]
        }
    },
    responses={
        200: {
            "application/json": {
                "type": "object",
                "properties": {
                    "access_token": {"type": "string", "example": "<access_token>"},
                    "refresh_token": {"type": "string", "example": "<refresh_token>"},
                    "username": {"type": "string", "example": "jdoe"}
                }
            }
        },
        401: {
            "description": "Credenciales inválidas."
        }
    }
)

logout_schema = extend_schema(
    tags=["Auth"],
    operation_id="Logout",
    summary="Cierra sesión",
    description="Revoca el token de actualización del usuario.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "refresh_token": {"type": "string", "example": "<refresh_token>"}
            },
            "required": ["refresh_token"]
        }
    },
    responses={
        204: {"description": "Logout exitoso."},
        400: {"description": "El token de actualización es obligatorio o inválido."}
    }
)

# ---------------------------------------------------
# ME SCHEMAS
# ---------------------------------------------------

user_me_schema = extend_schema(
    tags=["Auth"],
    operation_id="Usuario en sesión",
    summary="Visualiza o actualiza los datos del usuario autenticado",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "nombre": {"type": "string", "example": "John"},
                "apellido": {"type": "string", "example": "Doe"},
                "password": {"type": "string", "example": "newpassword123"}
            }
        }
    },

    responses={
        200: {
            "application/json": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "example": 1},
                    "username": {"type": "string", "example": "jdoe01"},
                    "nombre": {"type": "string", "example": "John"},
                    "apellido": {"type": "string", "example": "Doe"},
                    "is_active": {"type": "boolean", "example": True},
                    "created_at": {"type": "string", "example": "2023-01-15T12:00:00Z"}
                }
            }
        }
    }
)

# ---------------------------------------------------
# USER MANAGEMENT SCHEMAS
# ---------------------------------------------------

user_list_schema = extend_schema(
    tags=["Users"],
    operation_id="Listar Usuarios",
    summary="Obtiene una lista de todos los usuarios",
    description="Requiere el permiso `CanSee` para listar todos los usuarios.",
    responses={
        200: OpenApiExample(
            "Respuesta exitosa",
            value=[
                {
                    "id": 1,
                    "username": "jdoe01",
                    "nombre": "John",
                    "apellido": "Doe",
                    "is_active": True,
                    "created_at": "2023-01-15T12:00:00Z"
                }
            ]
        )
    }
)

user_create_schema = extend_schema(
    tags=["Users"],
    operation_id="Crear Usuario",
    summary="Crea un nuevo usuario",
    description="Requiere el permiso `CanEdit` para crear un usuario.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "nombre": {"type": "string", "example": "Jane"},
                "apellido": {"type": "string", "example": "Smith"},
                "password": {"type": "string", "example": "securepassword123"}
            },
            "required": ["nombre", "apellido", "password"]
        }
    },
    responses={
        201: {
            "type": "object",
            "properties": {
                "id": {"type": "integer", "example": 1},
                "username": {"type": "string", "example": "jsmith01"},
                "nombre": {"type": "string", "example": "Jane"},
                "apellido": {"type": "string", "example": "Smith"},
                "is_active": {"type": "boolean", "example": True},
                "created_at": {"type": "string", "example": "2023-01-15T12:00:00Z"}
            }
        }
    }
)


user_update_schema = extend_schema(
    tags=["Users"],
    operation_id="Actualizar Usuario",
    summary="Actualiza los datos de un usuario existente",
    description="Requiere el permiso `CanEdit` para actualizar un usuario.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "nombre": {"type": "string", "example": "Jane"},
                "apellido": {"type": "string", "example": "Doe"},
                "password": {"type": "string", "example": "newpassword123"}
            }
        }
    },
    responses={
        200: OpenApiExample(
            "Usuario Actualizado",
            value={
                "id": 1,
                "username": "jdoe01",
                "nombre": "Jane",
                "apellido": "Doe",
                "is_active": True,
                "created_at": "2023-01-15T12:00:00Z"
            }
        )
    }
)

user_destroy_schema = extend_schema(
    tags=["Users"],
    operation_id="Eliminar Usuario",
    summary="Elimina un usuario",
    description="Requiere el permiso `CanEdit` para eliminar un usuario.",
    responses={
        204: {"description": "Usuario eliminado exitosamente."}
    }
)

get_user_schema = extend_schema(
    tags=["Users"],
    operation_id="Detalle user",
    summary="Obtiene los detalles de un user específico",
    description="Devuelve los detalles de un user identificado por su ID.",
    responses={
        200: {
            "application/json": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "example": 1},
                    "username": {"type": "string", "example": "JoeD01"},
                    "nombre": {"type": "string", "example": "Joe."},
                    "Apellido": {"type": "string", "example": "Doe."},
                }
            }
        },
        404: {"description": "No encontrado."}
    }
)

# ---------------------------------------------------
# ROLE MANAGEMENT SCHEMAS
# ---------------------------------------------------

assign_role_schema = extend_schema(
    tags=["Roles"],
    operation_id="Asignar Rol a Usuario",
    summary="Asigna un rol a un usuario",
    description="Este endpoint permite asignar un rol existente a un usuario autenticado. Requiere el permiso 'OnlyAdmin'.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "user_id": {"type": "integer", "example": 1},
                "role_id": {"type": "integer", "example": 2}
            },
            "required": ["user_id", "role_id"]
        }
    },
    responses={
        200: {
            "application/json": {
                "type": "object",
                "properties": {
                    "status": {"type": "string", "example": "Rol asignado correctamente."}
                }
            }
        },
        403: {"description": "El usuario no tiene permiso para realizar esta acción."},
        400: {"description": "Datos inválidos."}
    }
)

remove_role_schema = extend_schema(
    tags=["Roles"],
    operation_id="Eliminar Rol de Usuario",
    summary="Elimina un rol de un usuario",
    description="Este endpoint permite eliminar un rol existente asignado a un usuario autenticado. Requiere el permiso 'OnlyAdmin'.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "user_id": {"type": "integer", "example": 1},
                "role_id": {"type": "integer", "example": 2}
            },
            "required": ["user_id", "role_id"]
        }
    },
    responses={
        200: {
            "application/json": {
                "type": "object",
                "properties": {
                    "status": {"type": "string", "example": "Rol eliminado correctamente."}
                }
            }
        },
        403: {"description": "El usuario no tiene permiso para realizar esta acción."},
        400: {"description": "Datos inválidos."}
    }
)


##
obtener_usuarios_sin_roles_schema = extend_schema(
    summary="Obtener Usuarios Sin Roles",
    description="Obtiene una lista de usuarios que no tienen roles asignados.",
    responses={
        200: {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "example": 1},
                    "username": {"type": "string", "example": "usuario1"},
                    "nombre": {"type": "string", "example": "Juan"},
                    "apellido": {"type": "string", "example": "Pérez"},
                },
            },
        },
        403: {"description": "Prohibido: el usuario no tiene permisos."},
    },
)


usuarios_con_roles_schema = extend_schema(
    summary="Obtener Usuarios Con Roles",
    description="Obtiene una lista de usuarios que tienen roles asignados, incluyendo sus roles.",
    responses={
        200: {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "example": 1},
                    "username": {"type": "string", "example": "jdoe"},
                    "nombre": {"type": "string", "example": "John"},
                    "apellido": {"type": "string", "example": "Doe"},
                    "roles": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "id": {"type": "integer", "example": 2},
                                "name": {"type": "string", "example": "Admin"},
                            },
                        },
                    },
                },
            },
        },
        403: {"description": "Prohibido: el usuario no tiene permisos."},
    },
)


