from django.db import models


class Manga(models.Model):
    title = models.CharField(max_length=100)
    description = models.TextField()
    # cover = models.ImageField()
    # rating = models.DecimalField()
