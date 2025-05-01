from ..models import Logs
from django.utils.timezone import now


def makelog(user, endpoint, action, data=None, tipo="aplicativo", object_id=None):
    """
    Registra un log en la tabla Logs con su tipo (aplicativo o seguridad).
    """
    log_message = f"El usuario {user.username} utilizo el recurso {endpoint} "


    if action == "POST":
        log_message += f"subiendo los siguientes datos: {data}."
    elif action == "GET" and object_id is None:
        log_message += "para obtener los datos."
    elif action == "GET" and object_id is not None:
        log_message += f"para obtener los datos del ID {object_id}."
    elif action in ["PUT", "PATCH"]:
        log_message += f"para modificar los siguientes datos: {data}."
    elif action == "DELETE":
        log_message += f"para eliminar los siguientes datos: {data}."

    Logs.objects.create(log=log_message, fecha_hora=now(), tipo=tipo)
