from decimal import Decimal
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Plancha, CortePlegado, PlanchaProveedor
from .serializers import PlanchaSerializer, ProveedorSerializer, CortePlegadoSerializer
from django.db.models import F, Value, Subquery, OuterRef
from django.db.models.functions import Abs
from django.db.models import FloatField
from .schemas import calcular_piezas_schema

class CalcularPiezasAPIView(APIView):
    permission_classes = [AllowAny]

    @calcular_piezas_schema
    def post(self, request):
        try:
            # Validar y convertir datos de entrada
            try:
                espesor = Decimal(request.data.get('espesor', 0))
                largo_pieza = Decimal(request.data.get('largo_pieza', 0))
                ancho_pieza = Decimal(request.data.get('ancho_pieza', 0))
                cantidad_golpes = int(request.data.get('cantidad_golpes', 0))
                cantidad_piezas = int(request.data.get('cantidad_piezas', 0))
            except (TypeError, ValueError) as e:
                print("Error al validar los datos de entrada:", str(e))
                return Response({"error": f"Datos de entrada inválidos: {str(e)}. Verifique los campos."}, status=status.HTTP_400_BAD_REQUEST)

            if any(value <= 0 for value in [espesor, largo_pieza, ancho_pieza, cantidad_golpes, cantidad_piezas]):
                print("Error: Todos los valores deben ser mayores a 0.")
                return Response({"error": "Todos los valores deben ser mayores a 0."}, status=status.HTTP_400_BAD_REQUEST)

            # Filtrar planchas disponibles
            planchas = Plancha.objects.filter(espesor=espesor)
            if not planchas.exists():
                print("No hay planchas disponibles con el espesor solicitado.")
                return Response({"error": "No hay planchas disponibles con el espesor solicitado."}, status=status.HTTP_404_NOT_FOUND)

            print("Número de planchas encontradas:", len(planchas))

            # Evaluar la mejor plancha
            plancha_ideal = None
            piezas_por_plancha = Decimal(0)
            menor_desperdicio = Decimal('Infinity')

            for plancha in planchas:
                ancho_plancha = Decimal(plancha.ancho)
                largo_plancha = Decimal(plancha.largo)

                # Obtener precio desde PlanchaProveedor
                plancha_proveedor = PlanchaProveedor.objects.filter(plancha=plancha).first()
                if not plancha_proveedor:
                    print(f"No se encontró proveedor para la plancha {plancha.id}")
                    continue
                costo_plancha = Decimal(plancha_proveedor.precio)

                # Calcular piezas por plancha para ambas orientaciones
                piezas_caso1 = (ancho_plancha // ancho_pieza) * (largo_plancha // largo_pieza)
                piezas_caso2 = (ancho_plancha // largo_pieza) * (largo_plancha // ancho_pieza)
                total_piezas = max(piezas_caso1, piezas_caso2)

                print(f"Plancha {plancha.id} - Total piezas posibles: {total_piezas}")

                if total_piezas > 0:
                    area_utilizada = total_piezas * largo_pieza * ancho_pieza
                    area_total = largo_plancha * ancho_plancha
                    desperdicio = area_total - area_utilizada

                    print(f"Plancha {plancha.id} - Desperdicio: {desperdicio}")

                    # Priorizar la plancha con menor desperdicio
                    if desperdicio < menor_desperdicio:
                        menor_desperdicio = desperdicio
                        plancha_ideal = plancha
                        piezas_por_plancha = total_piezas

            if not plancha_ideal:
                print("No se encontró una plancha adecuada.")
                return Response({"error": "No se encontró una plancha adecuada."}, status=status.HTTP_404_NOT_FOUND)

            print("Plancha ideal seleccionada:", plancha_ideal.id)

            # Obtener precio de la plancha seleccionada desde PlanchaProveedor
            plancha_proveedor = PlanchaProveedor.objects.filter(plancha=plancha_ideal).first()
            if not plancha_proveedor:
                print("No se encontró un proveedor para la plancha seleccionada.")
                return Response({"error": "No se encontró un proveedor para la plancha seleccionada."}, status=status.HTTP_404_NOT_FOUND)

            # Calcular el precio de los golpes y del corte plegado
            corte_plegado = (
                CortePlegado.objects.filter(espesor=espesor)
                .annotate(diferencia=Abs(F('largo') - Value(float(largo_pieza), output_field=FloatField())))
                .order_by('diferencia')
                .first()
            )
            if not corte_plegado:
                print("No se encontró información de corte y plegado para el espesor solicitado.")
                return Response({"error": "No se encontró información de corte y plegado para el espesor solicitado."}, status=status.HTTP_404_NOT_FOUND)

            print("Corte plegado seleccionado:", corte_plegado.id)

            precio_golpes = Decimal(cantidad_golpes) * Decimal(corte_plegado.precio)
            print("Precio por golpes:", precio_golpes)

            # Calcular el precio por unidad
            precio_por_pieza_plancha = Decimal(plancha_proveedor.precio) / piezas_por_plancha
            precio_por_unidad = precio_por_pieza_plancha + precio_golpes
            precio_total = precio_por_unidad * cantidad_piezas

            print("Precio por pieza de la plancha:", precio_por_pieza_plancha)
            print("Precio por unidad (incluye golpes):", precio_por_unidad)
            print("Precio total del trabajo:", precio_total)

            # Respuesta final
            response_data = {
                "plancha_ideal": PlanchaSerializer(plancha_ideal).data,
                "corte_plegado": CortePlegadoSerializer(corte_plegado).data,
                "precio_por_unidad": round(precio_por_unidad, 2),
                "precio_total": round(precio_total, 2),
                "precio_golpes": round(precio_golpes, 2),
                "piezas_por_plancha": piezas_por_plancha
            }
            return Response(response_data, status=status.HTTP_200_OK)

        except Exception as e:
            print("Error inesperado:", str(e))
            return Response({"error": f"Ocurrió un error inesperado: {str(e)}"}, status=status.HTTP_400_BAD_REQUEST)
