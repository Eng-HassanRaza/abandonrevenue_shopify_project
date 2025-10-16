from django.urls import path
from . import views

urlpatterns = [
    path('', views.landing_page, name='landing_page'),
    path('thank-you/', views.thank_you, name='thank_you'),
]

