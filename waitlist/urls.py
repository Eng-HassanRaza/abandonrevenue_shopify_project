from django.urls import path
from . import views

app_name = 'waitlist'

urlpatterns = [
    path('', views.landing_page, name='landing'),
    path('thank-you/', views.thank_you, name='thank_you'),
]

