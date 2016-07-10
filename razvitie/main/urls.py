# -*- coding: utf-8 -*-
__author__ = 'Kovach Y.V.'

from django.conf.urls import url, include
from main import views

urlpatterns = [
    url(r'^$', views.main_page),

]
