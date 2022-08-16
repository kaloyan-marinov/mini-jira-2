from django.shortcuts import render
from django.http import JsonResponse
from projects.models import Project
from django.core import serializers
from django.views.decorators.csrf import csrf_exempt
import json


@csrf_exempt  ## To exempt from default requirement for CSRF tokens to use postman
def get_or_post_to_projects(request):

    if request.method == "GET":
        # Serialize the data into json
        data = serializers.serialize("json", Project.objects.all())
        # Turn the JSON data into a dict and send as JSON response
        return JsonResponse(json.loads(data), safe=False)

    if request.method == "POST":
        # Turn the body into a dict
        body = json.loads(request.body.decode("utf-8"))
        # create the new name
        newrecord = Project.objects.create(name=body["name"])
        # Turn the object to json to dict, put in array to avoid non-iterable error
        data = json.loads(serializers.serialize("json", [newrecord]))
        # send json response with new object
        return JsonResponse(data, safe=False)


@csrf_exempt  ## To exempt from default requirement for CSRF tokens to use postman
def put_or_delete_to_project(request, id):
    if request.method == "PUT":
        # Turn the body into a dict
        body = json.loads(request.body.decode("utf-8"))
        # update the name
        Project.objects.filter(pk=id).update(name=body["name"])
        newrecord = Project.objects.filter(pk=id)
        # Turn the object to json to dict, put in array to avoid non-iterable error
        data = json.loads(serializers.serialize("json", newrecord))
        # send json response with updated object
        return JsonResponse(data, safe=False)

    if request.method == "DELETE":
        # delete the name, get all remaining records for response
        Project.objects.filter(pk=id).delete()
        newrecord = Project.objects.all()
        # Turn the results to json to dict, put in array to avoid non-iterable error
        data = json.loads(serializers.serialize("json", newrecord))
        # send json response with updated object
        return JsonResponse(data, safe=False)
