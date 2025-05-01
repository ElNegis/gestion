from drf_spectacular.utils import extend_schema, OpenApiExample

# ---------------------------------------------------
# PERMISOS SCHEMAS
# ---------------------------------------------------

# Permisos Schemas
list_permisos_schema = extend_schema(
    tags=["Permisos"],
    operation_id="Listar Permisos",
    summary="Obtiene una lista de todos los permisos",
    description="Devuelve una lista con todos los permisos registrados en el sistema.",
    responses={
        200: OpenApiExample(
            "Respuesta Exitosa",
            value=[
                {"id": 1, "name": "CanEdit", "description": "Permite editar contenidos"}
            ]
        )
    }
)

asignar_permiso_schema = extend_schema(
    tags=["Permisos"],
    operation_id="asignar_permiso",
    summary="Asigna un permiso a un rol",
    description="Este endpoint permite asignar un permiso existente a un rol usando los IDs del rol y del permiso.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "rol_id": {
                    "type": "integer",
                    "description": "ID del rol al que se desea asignar el permiso.",
                },
                "permiso_id": {
                    "type": "integer",
                    "description": "ID del permiso que se desea asignar al rol.",
                },
            },
            "required": ["rol_id", "permiso_id"],
        }
    },
    responses={
        200: {"type": "object", "properties": {"status": {"type": "string"}}},
        400: {"type": "object", "properties": {"error": {"type": "string"}}},
    },
    examples=[
        OpenApiExample(
            "Ejemplo de solicitud",
            description="Asigna el permiso con ID 2 al rol con ID 1.",
            value={"rol_id": 1, "permiso_id": 2},
        )
    ],
)

eliminar_permiso_schema = extend_schema(
    tags=["Permisos"],
    operation_id="eliminar_permiso",
    summary="Elimina un permiso de un rol",
    description="Este endpoint permite eliminar un permiso previamente asignado a un rol usando los IDs del rol y del permiso.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "rol_id": {
                    "type": "integer",
                    "description": "ID del rol del que se desea eliminar el permiso.",
                },
                "permiso_id": {
                    "type": "integer",
                    "description": "ID del permiso que se desea eliminar del rol.",
                },
            },
            "required": ["rol_id", "permiso_id"],
        }
    },
    responses={
        200: {"type": "object", "properties": {"status": {"type": "string"}}},
        400: {"type": "object", "properties": {"error": {"type": "string"}}},
    },
    examples=[
        OpenApiExample(
            "Ejemplo de solicitud",
            description="Elimina el permiso con ID 2 del rol con ID 1.",
            value={"rol_id": 1, "permiso_id": 2},
        )
    ],
)

get_permiso_schema = extend_schema(
    tags=["Permisos"],
    operation_id="Detalle Permiso",
    summary="Obtiene los detalles de un permiso específico",
    description="Devuelve los detalles de un permiso identificado por su ID.",
    responses={
        200: {
            "application/json": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "example": 1},
                    "name": {"type": "string", "example": "CanEdit"},
                    "description": {"type": "string", "example": "Permite editar contenidos."}
                }
            }
        },
        404: {"description": "No encontrado."}
    }
)



obtener_permisos=extend_schema(
    operation_id="obtener_permisos",
    summary="Obtener permisos de un rol",
    description="Devuelve los permisos asociados a un rol específico.",
    responses={
        200: {
            "type": "object",
            "properties": {
                "rol": {"type": "string", "example": "Admin"},
                "permisos": {
                    "type": "array",
                    "items": {
                        "type": "object",
                        "properties": {
                            "id": {"type": "integer", "example": 1},
                            "name": {"type": "string", "example": "CanEdit"},
                            "description": {"type": "string", "example": "Permiso para editar contenido"}
                        }
                    }
                }
            }
        },
        403: {
            "type": "object",
            "properties": {
                "detail": {"type": "string", "example": "El usuario no tiene los permisos requeridos."}
            }
        },
        404: {
            "type": "object",
            "properties": {
                "detail": {"type": "string", "example": "Rol no encontrado"}
            }
        }
    },
    tags=["Roles"]
)


obtener_permisos_user=extend_schema(
    operation_id="get_user_permissions",
    summary="Obtener permisos del usuario autenticado",
    description="Devuelve una lista de permisos asociados al usuario autenticado.",
    responses={
        200: {
            "type": "object",
            "properties": {
                "user": {"type": "string", "example": "admin"},
                "permissions": {
                    "type": "array",
                    "items": {
                        "type": "object",
                        "properties": {
                            "id": {"type": "integer", "example": 1},
                            "name": {"type": "string", "example": "CanEdit"},
                            "description": {"type": "string", "example": "Permiso para editar contenido"}
                        }
                    }
                }
            }
        },
        404: {"type": "object", "properties": {"detail": {"type": "string", "example": "Usuario no encontrado"}}}
    },
    tags=["Auth"]
)


# ---------------------------------------------------
# ROLES SCHEMAS
# ---------------------------------------------------

list_roles_schema = extend_schema(
    tags=["Roles"],
    operation_id="Listar Roles",
    summary="Obtiene una lista de todos los roles",
    description="Devuelve una lista con todos los roles registrados en el sistema.",
    responses={
        200: OpenApiExample(
            "Respuesta Exitosa",
            value=[
                {"id": 1, "name": "Admin", "description": "Administrador del sistema"}
            ]
        )
    }
)

create_role_schema = extend_schema(
    tags=["Roles"],
    operation_id="Crear Rol",
    summary="Crea un nuevo rol",
    description="Permite crear un nuevo rol con un nombre y una descripción.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "name": {"type": "string", "example": "Editor"},
                "description": {"type": "string", "example": "Puede editar contenidos."},
            },
            "required": ["name", "description"]
        }
    },
    responses={
        201: {"type": "object", "properties": {"id": {"type": "integer"}}}
    }
)

update_role_schema = extend_schema(
    tags=["Roles"],
    operation_id="Actualizar Rol",
    summary="Actualiza un rol existente",
    description="Permite actualizar el nombre y/o descripción de un rol.",
)

delete_role_schema = extend_schema(
    tags=["Roles"],
    operation_id="Eliminar Rol",
    summary="Elimina un rol",
    description="Permite eliminar un rol identificado por su ID.",
)

get_rol_schema = extend_schema(
    tags=["Roles"],
    operation_id="Detalle Rol",
    summary="Obtiene los detalles de un rol específico",
    description="Devuelve los detalles de un rol identificado por su ID.",
    responses={
        200: {
            "application/json": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "example": 1},
                    "name": {"type": "string", "example": "Admin"},
                    "description": {"type": "string", "example": "Administrador del sistema."}
                }
            }
        },
        404: {"description": "No encontrado."}
    }
)

patch_rol_schema = extend_schema(
    tags=["Roles"],
    operation_id="Actualizar Parcialmente Rol",
    summary="Actualiza parcialmente los datos de un rol",
    description="Permite modificar algunos campos del rol identificado por su ID.",
    request={
        "application/json": {
            "type": "object",
            "properties": {
                "name": {"type": "string", "example": "Editor"},
                "description": {"type": "string", "example": "Puede editar contenidos."}
            }
        }
    },
    responses={
        200: {
            "application/json": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "example": 1},
                    "name": {"type": "string", "example": "Editor"},
                    "description": {"type": "string", "example": "Puede editar contenidos."}
                }
            }
        },
        404: {"description": "No encontrado."}
    }
)

##Roles con permisos.
obtener_roles_con_permisos_schema = extend_schema(
    tags=["Roles"],
    operation_id="Obtener Roles con Permisos",
    summary="Lista los roles que tienen permisos asociados",
    description="Devuelve una lista de roles y sus permisos. Los roles sin permisos no se incluyen.",
    responses={
        200: {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "example": 1},
                    "name": {"type": "string", "example": "Administrador"},
                    "permisos": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "id": {"type": "integer", "example": 1},
                                "name": {"type": "string", "example": "CanEdit"},
                                "description": {"type": "string", "example": "Puede editar contenidos"}
                            }
                        }
                    }
                }
            }
        }
    }
)


obtener_roles_sin_permisos_schema = extend_schema(
    summary="Obtener Roles Sin Permisos",
    description="Obtiene una lista de roles que no tienen permisos asignados.",
    responses={
        200: {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "example": 1},
                    "name": {"type": "string", "example": "Rol sin permisos"},
                },
            },
        },
        403: {"description": "Prohibido: el usuario no tiene permisos."},
    },
)
