from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiExample
from drf_spectacular.types import OpenApiTypes

# Esquemas para la documentación de la API
mi_modelo_list_schema = extend_schema(
    summary="Listar todos los modelos",
    description="Retorna una lista de todos los modelos disponibles",
    tags=["MiMicroservicio"],
)

mi_modelo_retrieve_schema = extend_schema(
    summary="Obtener un modelo específico",
    description="Retorna los detalles de un modelo específico",
    tags=["MiMicroservicio"],
)

mi_modelo_create_schema = extend_schema(
    summary="Crear un nuevo modelo",
    description="Crea un nuevo modelo con los datos proporcionados",
    tags=["MiMicroservicio"],
)

mi_modelo_update_schema = extend_schema(
    summary="Actualizar un modelo",
    description="Actualiza los datos de un modelo existente",
    tags=["MiMicroservicio"],
)

mi_modelo_delete_schema = extend_schema(
    summary="Eliminar un modelo",
    description="Elimina un modelo existente",
    tags=["MiMicroservicio"],
)