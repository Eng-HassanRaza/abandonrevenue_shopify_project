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

            return redirect('waitlist:thank_you')
        else:
            # If form is invalid, show errors
            print(f"Form errors: {form.errors}")
    else:
        form = WaitlistForm()

    return render(request, 'waitlist/landing.html', {'form': form})


def thank_you(request):
    return render(request, 'waitlist/thank_you.html')


def send_welcome_email(email):
    subject = 'Welcome to TemplateForge! 🎉 (50% OFF Early Access)'

    html_message = render_to_string('waitlist/welcome_email.html', {
        'email': email,
    })

    plain_message = f"""
    Welcome to TemplateForge! 👋

    Hey there, Email Innovator!

    Welcome to the TemplateForge family! We're absolutely thrilled to have you join our
    community of forward-thinking Shopify store owners.

    WHAT IS TEMPLATEFORGE?
    TemplateForge is your AI-powered email assistant that generates high-converting,
    on-brand email templates for every touchpoint in your customer journey. From welcome
    sequences to post-purchase follow-ups, we craft emails that sound authentically you.

    YOUR EXCLUSIVE EARLY ACCESS CODE
    ═══════════════════════════════
    Code: FIRST50
    Discount: 50% OFF Your First Month
    Valid: 48 hours after launch
    ═══════════════════════════════

    Save this code! When we launch, use FIRST50 at checkout to get 50% off your first month.

    WHAT YOU'LL GET:
    ✓ AI-generated emails in your unique brand voice
    ✓ Welcome sequences that convert browsers into buyers
    ✓ Cart recovery emails with personality, not pushy sales speak
    ✓ Post-purchase follow-ups that build lasting relationships
    ✓ Seasonal campaigns written on-brand, every time
    ✓ Seamless Shopify integration
    ✓ Priority customer support
    ✓ Early access to new features

    We're putting the finishing touches on TemplateForge to make it the most intuitive,
    powerful email tool for Shopify stores. You'll be among the very first to know when we launch!

    Questions? Ideas? Just want to chat?
    Hit reply to this email - we read every message and we'd love to hear from you.

    Excited to have you on board!

    The TemplateForge Team
    Building the future of email marketing, one template at a time

    ---
    AI-Crafted. Always On-Brand. Uniquely You.
    © 2025 TemplateForge. All rights reserved.
    """

    try:
        send_mail(
            subject,
            plain_message,
            settings.DEFAULT_FROM_EMAIL,
            [email],
            html_message=html_message,
            fail_silently=True,
        )
    except Exception as e:
        import logging
        logger = logging.getLogger(__name__)
        logger.error(f"Failed to send welcome email to {email}: {e}")


