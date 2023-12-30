# Arrange for every command to be printed before it is executed.
set -o xtrace

# Arrange for this script to exit immediately
# if any subsequent(*) commands which fail.
set -e

http POST \
   localhost:8000/api/sign_in \
   username=${USERNAME} \
   password=${PASSWORD}

export SESSION_ID=<tbd>

export CSRF_TOKEN=<tbd>

http \
   localhost:8000/api/tasks \
   cookie:sessionid=${SESSION_ID}

echo ""
curl \
   --verbose \
   localhost:8000/api/tasks \
   | json_pp

# # ...
# < HTTP/1.1 200 OK
# # ...
# {
#    "items" : []
# }

echo ""
curl \
   --verbose \
   --request POST \
   --header "Content-Type: application/json" \
   --data '{
      "category": "health"
   }' \
   localhost:8000/api/tasks \
   | json_pp

# # ...
# < HTTP/1.1 400 Bad Request
# # ...
# {
#    "error" : "Bad Request",
#    "message" : "The request body has to provide values for each of 'category' and 'description'."
# }

echo ""
curl \
   --verbose \
   --request POST \
   --header "Content-Type: application/json" \
   --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
   --header "X-CSRFToken: ${CSRF_TOKEN}" \
   --data '{
      "category": "health",
      "description": "go to the doctor"
   }' \
   localhost:8000/api/tasks \
   | json_pp

# # ...
# < HTTP/1.1 201 Created
# # ...
# {
#    "category" : "health",
#    "description" : "go to the doctor",
#    "id" : 1
# }



echo ""
curl \
   --verbose \
   --request POST \
   --header "Content-Type: application/json" \
   --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
   --header "X-CSRFToken: ${CSRF_TOKEN}" \
   --data '{
      "category": "work",
      "description": "build a web application using Django"
   }' \
   localhost:8000/api/tasks \
   | json_pp

# # ...
# < HTTP/1.1 201 Created
# # ...
# {
#    "category" : "work",
#    "description" : "build a web application using Django",
#    "id" : 2
# }

echo ""
curl localhost:8000/api/tasks \
   --verbose \
   | json_pp

# # ...
# < HTTP/1.1 200 OK
# # ...
# {
#    "items" : [
#       {
#          "category" : "health",
#          "description" : "go to the doctor",
#          "id" : 1
#       },
#       {
#          "category" : "work",
#          "description" : "build a web application using Django",
#          "id" : 2
#       }
#    ]
# }



echo ""
curl \
   --verbose \
   --request POST \
   --header "Content-Type: application/json" \
   --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
   --header "X-CSRFToken: ${CSRF_TOKEN}" \
   --data '{
      "category": "VACATON",
      "description": "look up INTRESTING towns in SICLY to VISITT"
   }' \
   localhost:8000/api/tasks \
   | json_pp

# # ...
# < HTTP/1.1 201 Created
# # ...
# {
#    "category" : "VACATON",
#    "description" : "look up INTRESTING towns in SICLY to VISITT",
#    "id" : 3
# }

echo ""
curl \
   --verbose \
   localhost:8000/api/tasks/3 \
   | json_pp

# # ...
# < HTTP/1.1 200 OK
# # ...
# {
#    "category" : "VACATON",
#    "description" : "look up INTRESTING towns in SICLY to VISITT",
#    "id" : 3
# }

echo ""
curl \
   --verbose \
   --request PUT \
   --header "Content-Type: application/json" \
   --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
   --header "X-CSRFToken: ${CSRF_TOKEN}" \
   --data '{
      "category": "vacation",
      "description": "look up interesting towns in Sicily to visit"
   }' \
   localhost:8000/api/tasks/3 \
   | json_pp

# # ...
# < HTTP/1.1 200 OK
# # ...
# {
#    "category" : "vacation",
#    "description" : "look up interesting towns in Sicily to visit",
#    "id" : 3
# }

echo ""
curl \
   --verbose \
   --request DELETE \
   localhost:8000/api/tasks/2

# # ...
# < HTTP/1.1 204 No Content
# # ...
# <no output>
# ```