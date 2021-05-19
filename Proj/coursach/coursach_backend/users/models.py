from django.db import models
from django.contrib.auth.models import AbstractUser


class User(AbstractUser):
    favourite_manga = models.JSONField(default=dict)

