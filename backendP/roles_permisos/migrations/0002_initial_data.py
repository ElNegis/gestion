from django.db import migrations

def create_permissions(apps, schema_editor):
    Permiso = apps.get_model('roles_permisos', 'Permiso')
    permissions = [
        {'name': 'Users', 'description': 'Modulos de Usuarios'},
        {'name': 'Ventas', 'description': 'Modulos de venta'},
        {'name': 'Planchas', 'description': 'Modulos de planchas,proveedores y cortes plegado'},
        {'name': 'Logs', 'description': 'Modulos de planchas,proveedores y cortes plegado'},
        {'name': 'NoAccess', 'description': 'Sin acceso'},
    ]

    for perm in permissions:
        Permiso.objects.update_or_create(
            name=perm['name'],
            defaults={'description': perm['description']}
        )

class Migration(migrations.Migration):
    dependencies = [
        ('roles_permisos', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(create_permissions),
    ]
