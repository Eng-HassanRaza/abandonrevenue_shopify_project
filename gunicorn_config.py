import multiprocessing

bind = "127.0.0.1:8000"
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "sync"
worker_connections = 1000
max_requests = 1000
max_requests_jitter = 50
timeout = 30
keepalive = 2

errorlog = "/home/ubuntu/abandonrevenue_shopify_project/logs/gunicorn-error.log"
accesslog = "/home/ubuntu/abandonrevenue_shopify_project/logs/gunicorn-access.log"
loglevel = "info"

daemon = False
pidfile = "/home/ubuntu/abandonrevenue_shopify_project/gunicorn.pid"

proc_name = "abandonrevenue_gunicorn"

