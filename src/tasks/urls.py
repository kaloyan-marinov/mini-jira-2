from django.urls import path
from . import views

urlpatterns = [
    path(
        "tasks",
        views.process_tasks,
        name="process-tasks",
    ),
    path(
        "tasks/<int:task_id>",
        views.process_task,
        name="process-task",
    ),
    path(
        "sign_in",
        views.sign_in,
        name="sign-in",
    ),
]
