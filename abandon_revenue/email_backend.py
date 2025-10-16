import ssl
from django.core.mail.backends.smtp import EmailBackend as SMTPBackend


class CustomEmailBackend(SMTPBackend):
    """Custom email backend that disables SSL certificate verification."""
    
    def open(self):
        if self.connection:
            return False
        
        connection_params = {'timeout': self.timeout} if self.timeout else {}
        
        if self.use_ssl:
            connection_params['context'] = ssl.create_default_context()
            connection_params['context'].check_hostname = False
            connection_params['context'].verify_mode = ssl.CERT_NONE
        
        try:
            self.connection = self.connection_class(
                self.host, self.port, **connection_params
            )
            
            if not self.use_ssl and self.use_tls:
                self.connection.starttls(context=ssl.create_default_context())
            
            if self.username and self.password:
                self.connection.login(self.username, self.password)
            
            return True
        except Exception:
            if not self.fail_silently:
                raise

