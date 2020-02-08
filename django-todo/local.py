# Overrides
from .settings import *  # noqa: F401
import os

SECRET_KEY = os.getenv('DJANGO_SECRET_KEY', 'change-me-pls')

DEBUG = os.getenv('DJANGO_DEBUG', 'false').lower() == 'true'

DATABASES = {
    'default': {
        'ENGINE': os.getenv('DB_ENGINE', 'django.db.backends.postgresql'),
        'NAME': os.getenv('DB_NAME'),
        'USER': os.getenv('DB_USER'),
        'PASSWORD': os.getenv('DB_PASSWORD'),
        'HOST': os.getenv('DB_HOST'),
        'PORT': os.getenv('DB_PORT'),
    },
}

EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# App settings
TODO_STAFF_ONLY = (os.getenv('TODO_STAFF_ONLY', 'false').lower() == 'true')
TODO_DEFAULT_LIST_SLUG = os.getenv('TODO_DEFAULT_LIST_SLUG', 'tickets')
TODO_DEFAULT_ASSIGNEE = os.getenv('TODO_DEFAULT_ASSIGNEE', None)
TODO_PUBLIC_SUBMIT_REDIRECT = os.getenv('TODO_PUBLIC_SUBMIT_REDIRECT', '/')

# FIXME: pass from envs
ALLOWED_HOSTS = ["*"]
