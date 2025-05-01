from django.db import migrations

def create_admin_role(apps, schema_editor):
    Rol = apps.get_model('roles_permisos', 'Rol')
    Permiso = apps.get_model('roles_permisos', 'Permiso')
    RolPermiso=apps.get_model('roles_permisos', 'RolPermiso')
    User=apps.get_model('users', 'User')

    admin_role, created = Rol.objects.get_or_create(
        name='userManager',
    defaults={'description': 'Gestionados de Usuarios'})

    permisos = Permiso.objects.filter(id__in=[1,4])

    for permiso in permisos:
        RolPermiso.objects.get_or_create(rol=admin_role, permiso=permiso)

    superuser = User.objects.filter(is_superuser=True).first()
    if superuser:
        superuser.roles.add(admin_role)

class Migration(migrations.Migration):
    dependencies = [
        ('users','0004_initial_user'),
        ('roles_permisos', '0002_initial_data'),
    ]
    operations = [
        migrations.RunPython(create_admin_role),
    ]