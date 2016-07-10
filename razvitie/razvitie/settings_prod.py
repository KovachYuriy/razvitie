import os
import dj_database_url
from .settings import *  # NOQA

DEBUG = False

STATIC_ROOT = os.getenv('STATIC_ROOT')


DATABASES = {
    'default': dj_database_url.config(
        env='DATABASE_URL',
        default='postgres://localhost/demo')}
