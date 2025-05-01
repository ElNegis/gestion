from django.db import migrations
from users.models import User

def create_initial_superuser(apps, schema_editor):
    if not User.objects.filter(username='admin').exists():
        User.objects.create_superuser(
            username='user01',
            password='12#insecurePassword#12',
            nombre='Test',
            apellido='User'
        )


class Migration(migrations.Migration):
    dependencies = [
        ('users', '0003_user_apellido_user_nombre_alter_user_created_at_and_more'),
    ]

    operations = [
        migrations.RunPython(create_initial_superuser),
    ]
