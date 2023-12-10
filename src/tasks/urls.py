from django.urls import path
from . import views

urlpatterns = [
    path("tasks", views.get_tasks, name="get-tasks"),
]
