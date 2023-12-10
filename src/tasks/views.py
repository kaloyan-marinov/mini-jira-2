from django.shortcuts import render

from rest_framework.decorators import api_view
from rest_framework.response import Response

from .models import Task


@api_view(["GET"])
def get_tasks(request):
    tasks = Task.objects.all()
    data = {
        "items": [
            {
                "id": t.id,
                "category": t.category,
                "description": t.description,
            }
            for t in tasks
        ]
    }
    return Response(data)
