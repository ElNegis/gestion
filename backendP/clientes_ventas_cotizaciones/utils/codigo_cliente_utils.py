from clientes_ventas_cotizaciones.models import Cliente
import re


def generar_codigo_cliente(nombre: str, apellido: str) -> str:
    """
    Genera un código único para un cliente basado en su nombre y apellido.

    Args:
        nombre (str): Nombre del cliente.
        apellido (str): Apellido del cliente.

    Returns:
        str: Código único en el formato '<InicialNombre><Apellido><Número>'.
    """
    # Obtener las iniciales del nombre y apellido
    nombre_inicial = nombre[0].upper() if nombre else ""
    apellido = re.sub(r'\s+', '', apellido.title())  # Formatea el apellido (elimina espacios y lo capitaliza)
    base_codigo = f"{nombre_inicial}{apellido}"

    # Inicializar contador y generar el primer código
    counter = 1
    codigo_cliente = f"{base_codigo}#{counter:02d}"

    # Verificar si el código ya existe en la base de datos
    while Cliente.objects.filter(codigo_clien=codigo_cliente).exists():
        counter += 1
        codigo_cliente = f"{base_codigo}#{counter:02d}"

    return codigo_cliente
