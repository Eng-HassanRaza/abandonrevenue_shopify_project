from django import forms
from .models import WaitlistEntry


class WaitlistForm(forms.ModelForm):
    class Meta:
        model = WaitlistEntry
        fields = ['email']
        widgets = {
            'email': forms.EmailInput(attrs={
                'placeholder': 'Enter your email address',
                'class': 'email-input'
            })
        }


