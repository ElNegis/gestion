# Generated by Django 4.2.18 on 2025-01-26 05:28

import datetime
from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('cotizador', '0006_cotizacion'),
    ]

    operations = [
        migrations.CreateModel(
            name='Cliente',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ci', models.CharField(default='-', max_length=250)),
                ('email', models.EmailField(blank=True, max_length=250, null=True)),
                ('telefono', models.CharField(default='-', max_length=250)),
                ('nombre', models.CharField(max_length=255)),
                ('apellido', models.CharField(max_length=255)),
                ('direccion', models.TextField(blank=True, null=True)),
                ('codigo_clien', models.CharField(blank=True, max_length=20, unique=True)),
                ('creado_en', models.DateTimeField(default=django.utils.timezone.now)),
            ],
            options={
                'verbose_name': 'Cliente',
                'verbose_name_plural': 'Clientes',
                'db_table': 'clientes',
            },
        ),
        migrations.CreateModel(
            name='Venta',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fecha_venta', models.DateField(default=datetime.date.today)),
                ('total', models.DecimalField(decimal_places=2, max_digits=10)),
                ('cliente', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='ventas', to='clientes_ventas_cotizaciones.cliente')),
                ('usuario', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='ventas', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'verbose_name': 'Venta',
                'verbose_name_plural': 'Ventas',
                'db_table': 'ventas',
            },
        ),
        migrations.CreateModel(
            name='Cotizacion',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('pieza', models.CharField(default='-', max_length=250)),
                ('precio', models.DecimalField(decimal_places=2, max_digits=10)),
                ('fecha_cotizacion', models.DateField(default=datetime.date.today)),
                ('total_estimado', models.DecimalField(decimal_places=2, max_digits=10)),
                ('detalles', models.TextField()),
                ('corte_plegado', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='cotizaciones', to='cotizador.corteplegado')),
                ('plancha', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='cotizaciones', to='cotizador.plancha')),
                ('venta', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='cotizaciones', to='clientes_ventas_cotizaciones.venta')),
            ],
            options={
                'verbose_name': 'Cotización',
                'verbose_name_plural': 'Cotizaciones',
                'db_table': 'cotizaciones',
            },
        ),
    ]
