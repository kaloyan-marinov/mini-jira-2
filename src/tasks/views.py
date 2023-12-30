from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import AnonymousUser
from django.contrib.auth import authenticate, login

from rest_framework.decorators import api_view, authentication_classes
from rest_framework.response import Response
from rest_framework.authentication import SessionAuthentication

from .models import Task


@api_view(["POST"])
def sign_in(request):
    # username = request.POST["username"]
    # password = request.POST["password"]
    username = request.data.get("username")
    password = request.data.get("password")
    user = authenticate(request, username=username, password=password)
    if user is not None:
        login(request, user)
        return Response(
            status=204,
        )
    else:
        # Return an 'invalid login' error message.
        return Response(
            data={
                "error": "Unauthorized",
                "message": "Your attempt at using BasicAuthentication failed.",
            },
            status=401,
        )


@api_view(["GET", "POST"])
@authentication_classes([SessionAuthentication])
# @login_required
def process_tasks(request):
    # if isinstance(request.user, AnonymousUser):
    if not request.user.is_authenticated:
        return Response(
            data={
                "error": "Unauthorized",
                "message": "Your attempt at using SessionAuthentication failed.",
            },
            status=401,
        )

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
