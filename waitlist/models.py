from django.db import models
from django.utils import timezone


class WaitlistEntry(models.Model):
    email = models.EmailField(unique=True)
    created_at = models.DateTimeField(default=timezone.now)
    
    class Meta:
        ordering = ['-created_at']
        verbose_name_plural = 'Waitlist Entries'
    
    def __str__(self):
        return self.email


