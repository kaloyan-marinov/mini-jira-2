from django.shortcuts import render

from rest_framework.decorators import api_view
from rest_framework.response import Response

from .models import Task


@api_view(["GET", "POST"])
def process_tasks(request):
    if request.method == "POST":
        category = request.data.get("category")
        description = request.data.get("description")

        if category and description:
            t = Task(category=category, description=description)
            t.save()
            return Response(
                data={
                    "id": t.id,
                    "category": t.category,
                    "description": t.description,
                },
                status=201,
            )

        return Response(
            data={
                "error": "Bad Request",
                "message": (
                    "The request body has to provide values"
                    " for each of 'category' and 'description'."
                ),
            },
            status=400,
        )
    elif request.method == "GET":
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


@api_view(["GET", "PUT", "DELETE"])
def process_task(request, task_id):
    t = Task.objects.get(id=task_id)

    if request.method == "GET":
        return Response(
            {
                "id": t.id,
                "category": t.category,
                "description": t.description,
            }
        )

    elif request.method == "PUT":
        category = request.data.get("category")
        if category is not None:
            t.category = category

        description = request.data.get("description")
        if description is not None:
            t.description = description

        t.save()

        return Response(
            {
                "id": t.id,
                "category": t.category,
                "description": t.description,
            }
        )

    elif request.method == "DELETE":
        t.delete()
        return Response(
            status=204,
        )
