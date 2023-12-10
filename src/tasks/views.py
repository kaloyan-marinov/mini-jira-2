from django.shortcuts import render

from rest_framework.decorators import api_view
from rest_framework.response import Response


@api_view(["GET"])
def get_tasks(request):
    data = {
        "items": [
            {
                "id": 1,
                "category": "health",
                "description": "go to the doctor",
            },
            {
                "id": 2,
                "category": "work",
                "description": "build a web application using Django",
            },
            {
                "id": 3,
                "category": "vacation",
                "description": "look up interesting towns in Sicily to visit",
            },
        ]
    }
    return Response(data)
