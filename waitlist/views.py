from django.shortcuts import render, redirect
from django.core.mail import send_mail
from django.template.loader import render_to_string
from django.conf import settings
from .forms import WaitlistForm
from .models import WaitlistEntry


def landing_page(request):
    if request.method == 'POST':
        form = WaitlistForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data['email']
            
            entry, created = WaitlistEntry.objects.get_or_create(email=email)
            
            send_welcome_email(email)
            
            return redirect('thank_you')
    else:
        form = WaitlistForm()
    
    return render(request, 'waitlist/landing.html', {'form': form})


def thank_you(request):
    return render(request, 'waitlist/thank_you.html')


def send_welcome_email(email):
    subject = 'Welcome to Abandon Revenue - Exclusive Early Access'
    
    html_message = render_to_string('waitlist/welcome_email.html', {
        'email': email,
    })
    
    plain_message = f"""
    Welcome to Abandon Revenue!
    
    Thank you for joining our waitlist! We're excited to have you on board.
    
    As an early supporter, you'll get UNLIMITED FREE ACCESS when we launch!
    
    What's Abandon Revenue?
    Turn abandoned carts into revenue with personalized video emails. Send custom videos featuring your face or celebrity endorsements with the exact products your customers left behind.
    
    What you'll get:
    - Unlimited video emails
    - Personalized video creation
    - Full Shopify integration
    - Analytics dashboard
    - Priority support
    
    We'll notify you as soon as we launch. Get ready to recover those lost sales!
    
    Best regards,
    The Abandon Revenue Team
    """
    
    try:
        send_mail(
            subject,
            plain_message,
            settings.DEFAULT_FROM_EMAIL,
            [email],
            html_message=html_message,
            fail_silently=False,
        )
    except Exception as e:
        print(f"Error sending email: {e}")


