from django.db import models


class Task(models.Model):
    category = models.CharField(max_length=64, unique=True)
    description = models.CharField(max_length=256)
