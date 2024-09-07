# Generated by Django 5.0.7 on 2024-09-03 16:35

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('members', '0003_remove_customuser_alt_email'),
    ]

    operations = [
        migrations.CreateModel(
            name='FileModel',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200, unique=True)),
                ('type', models.CharField(choices=[('PD', 'pdf'), ('IM', 'image'), ('LI', 'link')], max_length=2)),
                ('file', models.FileField(blank=True, null=True, upload_to='files/')),
                ('image', models.ImageField(blank=True, null=True, upload_to='images/')),
                ('url', models.URLField(blank=True, max_length=500, null=True)),
                ('uploaded_at', models.DateTimeField(auto_now_add=True, db_index=True)),
            ],
        ),
        migrations.AlterField(
            model_name='customuser',
            name='email',
            field=models.EmailField(max_length=254, unique=True),
        ),
        migrations.AlterField(
            model_name='customuser',
            name='github',
            field=models.URLField(blank=True, default=''),
        ),
        migrations.AlterField(
            model_name='customuser',
            name='linkedin',
            field=models.URLField(blank=True, default=''),
        ),
    ]