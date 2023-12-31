# Arrange for every command to be printed before it is executed.
set -o xtrace

# Arrange for this script to exit immediately
# if any subsequent(*) commands which fail.
set -e

TEMP_FILE=response-with-sessionid-and-csrftoken.txt

curl \
   --trace-ascii ${TEMP_FILE} \
   --header "Content-Type: application/json" \
   --data "{
      \"username\": \"${USERNAME}\",
      \"password\": \"${PASSWORD}\"
   }" \
   localhost:8000/api/sign_in


# Extract the CSRF token,
# which is contained in the preceding command's output.
regex="Set-Cookie:  csrftoken=([0-9a-zA-Z]+);"
line_with_csrf_token=$(grep "Set-Cookie:  csrftoken" $TEMP_FILE)
if [[ $line_with_csrf_token =~ $regex ]]
then
   CSRF_TOKEN="${BASH_REMATCH[1]}"
   echo "identified the CSRF token to be equal to ${CSRF_TOKEN}"
else
   echo "$line_with_csrf_token doesn't match" >&2
fi


# Extract the Session ID,
# which is contained in the preceding command's output.
regex="Set-Cookie:  sessionid=([0-9a-zA-Z]+);"
line_with_session_id=$(grep "Set-Cookie:  sessionid" $TEMP_FILE)
if [[ $line_with_session_id =~ $regex ]]
then
   SESSION_ID="${BASH_REMATCH[1]}"
   echo "identified the Session ID to be equal to ${SESSION_ID}"
else
   echo "$line_with_session_id doesn't match" >&2
fi

# rm ${TEMP_FILE}
# 
# http \
#    localhost:8000/api/tasks \
#    cookie:sessionid=${SESSION_ID}

# echo ""
# curl \
#    --verbose \
#    --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
#    --header "X-CSRFToken: ${CSRF_TOKEN}" \
#    localhost:8000/api/tasks \
#    | json_pp

# # # ...
# # < HTTP/1.1 200 OK
# # # ...
# # {
# #    "items" : []
# # }

# echo ""
# curl \
#    --verbose \
#    --request POST \
#    --header "Content-Type: application/json" \
#    --data '{
#       "category": "health"
#    }' \
#    localhost:8000/api/tasks \
#    | json_pp

# # # ...
# # < HTTP/1.1 400 Bad Request
# # # ...
# # {
# #    "error" : "Bad Request",
# #    "message" : "The request body has to provide values for each of 'category' and 'description'."
# # }

# echo ""
# curl \
#    --verbose \
#    --request POST \
#    --header "Content-Type: application/json" \
#    --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
#    --header "X-CSRFToken: ${CSRF_TOKEN}" \
#    --data '{
#       "category": "health",
#       "description": "go to the doctor"
#    }' \
#    localhost:8000/api/tasks \
#    | json_pp

# # # ...
# # < HTTP/1.1 201 Created
# # # ...
# # {
# #    "category" : "health",
# #    "description" : "go to the doctor",
# #    "id" : 1
# # }



# echo ""
# curl \
#    --verbose \
#    --request POST \
#    --header "Content-Type: application/json" \
#    --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
#    --header "X-CSRFToken: ${CSRF_TOKEN}" \
#    --data '{
#       "category": "work",
#       "description": "build a web application using Django"
#    }' \
#    localhost:8000/api/tasks \
#    | json_pp

# # # ...
# # < HTTP/1.1 201 Created
# # # ...
# # {
# #    "category" : "work",
# #    "description" : "build a web application using Django",
# #    "id" : 2
# # }

# echo ""
# curl \
#    --verbose \
#    --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
#    --header "X-CSRFToken: ${CSRF_TOKEN}" \
#    localhost:8000/api/tasks \
#    | json_pp

# # # ...
# # < HTTP/1.1 200 OK
# # # ...
# # {
# #    "items" : [
# #       {
# #          "category" : "health",
# #          "description" : "go to the doctor",
# #          "id" : 1
# #       },
# #       {
# #          "category" : "work",
# #          "description" : "build a web application using Django",
# #          "id" : 2
# #       }
# #    ]
# # }



# echo ""
# curl \
#    --verbose \
#    --request POST \
#    --header "Content-Type: application/json" \
#    --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
#    --header "X-CSRFToken: ${CSRF_TOKEN}" \
#    --data '{
#       "category": "VACATON",
#       "description": "look up INTRESTING towns in SICLY to VISITT"
#    }' \
#    localhost:8000/api/tasks \
#    | json_pp

# # # ...
# # < HTTP/1.1 201 Created
# # # ...
# # {
# #    "category" : "VACATON",
# #    "description" : "look up INTRESTING towns in SICLY to VISITT",
# #    "id" : 3
# # }

# echo ""
# curl \
#    --verbose \
#    --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
#    --header "X-CSRFToken: ${CSRF_TOKEN}" \
#    localhost:8000/api/tasks/3 \
#    | json_pp

# # # ...
# # < HTTP/1.1 200 OK
# # # ...
# # {
# #    "category" : "VACATON",
# #    "description" : "look up INTRESTING towns in SICLY to VISITT",
# #    "id" : 3
# # }

# echo ""
# curl \
#    --verbose \
#    --request PUT \
#    --header "Content-Type: application/json" \
#    --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
#    --header "X-CSRFToken: ${CSRF_TOKEN}" \
#    --data '{
#       "category": "vacation",
#       "description": "look up interesting towns in Sicily to visit"
#    }' \
#    localhost:8000/api/tasks/3 \
#    | json_pp

# # # ...
# # < HTTP/1.1 200 OK
# # # ...
# # {
# #    "category" : "vacation",
# #    "description" : "look up interesting towns in Sicily to visit",
# #    "id" : 3
# # }

# echo ""
# curl \
#    --verbose \
#    --request DELETE \
#    --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
#    --header "X-CSRFToken: ${CSRF_TOKEN}" \
#    localhost:8000/api/tasks/2

# # # ...
# # < HTTP/1.1 204 No Content
# # # ...
# # <no output>
# # ```