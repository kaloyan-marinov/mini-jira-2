from django.shortcuts import render
from django.contrib.auth import authenticate, login

from rest_framework.decorators import api_view
from rest_framework.response import Response


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
