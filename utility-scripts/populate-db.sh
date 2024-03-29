# Ensure that
# this script will have access to the `USERNAME` and `PASSWORD` variables
# from the following file:
source .env

# Arrange for every command to be printed before it is executed.
set -o xtrace

# Arrange for this script to exit immediately
# if any one of the subsequent commands fails.
set -e

TEMP_FILE=response-with-sessionid-and-csrftoken.txt

# If the value of the `HOST_IP` environment variable has length zero
# (i.e. if that environment variable has not been set),
# provide a default value for that variable.
if [[ -z "${HOST_IP}" ]]; then
  HOST_IP="localhost"
else
  HOST_IP="${HOST_IP}"
fi

# Repeat the above, but this time for the `HOST_PORT` environment variable.
if [[ -z "${HOST_PORT}" ]]; then
  HOST_PORT="8000"
else
  HOST_PORT="${HOST_PORT}"
fi

curl \
   --trace-ascii ${TEMP_FILE} \
   --header "Content-Type: application/json" \
   --data "{
      \"username\": \"${USERNAME}\",
      \"password\": \"${PASSWORD}\"
   }" \
   ${HOST_IP}:${HOST_PORT}/api/sign_in

cat ${TEMP_FILE}

# # ...
# < HTTP/1.1 204 No Content
# # ...
# <no output>
# ```

# Adapt the example from
# https://stackoverflow.com/questions/1891797/capturing-groups-from-a-grep-regex
# in order to
# extract the CSRF token,
# which is contained in the preceding command's output.
reg_exp_for_csrf_token="csrftoken=([0-9a-zA-Z]+);"
line_with_csrf_token=$(
   grep \
      --extended-regexp \
      $reg_exp_for_csrf_token \
      $TEMP_FILE
)
if [[ $line_with_csrf_token =~ $reg_exp_for_csrf_token ]]
then
   CSRF_TOKEN="${BASH_REMATCH[1]}"
   echo "identified the CSRF token to be equal to ${CSRF_TOKEN}"
else
   echo "no match found in '$line_with_csrf_token' - aborting!" >&2
   exit 1
fi

# Adapt the example from
# https://stackoverflow.com/questions/1891797/capturing-groups-from-a-grep-regex
# in order to
# extract the Session ID,
# which is contained in the preceding command's output.
reg_exp_for_session_id="sessionid=([0-9a-zA-Z]+);"
line_with_session_id=$(
   grep \
      --extended-regexp \
      $reg_exp_for_session_id \
      $TEMP_FILE
)
if [[ $line_with_session_id =~ $reg_exp_for_session_id ]]
then
   SESSION_ID="${BASH_REMATCH[1]}"
   echo "identified the Session ID to be equal to ${SESSION_ID}"
else
   echo "no match found in '$line_with_session_id' - aborting!" >&2
   exit 1
fi

rm ${TEMP_FILE}

echo ""
curl \
   --verbose \
   --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
   --header "X-CSRFToken: ${CSRF_TOKEN}" \
   ${HOST_IP}:${HOST_PORT}/api/tasks \
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
   --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
   --header "X-CSRFToken: ${CSRF_TOKEN}" \
   --data '{
      "category": "health"
   }' \
   ${HOST_IP}:${HOST_PORT}/api/tasks \
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
   ${HOST_IP}:${HOST_PORT}/api/tasks \
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
   ${HOST_IP}:${HOST_PORT}/api/tasks \
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
curl ${HOST_IP}:${HOST_PORT}/api/tasks \
   --verbose \
   --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
   --header "X-CSRFToken: ${CSRF_TOKEN}" \
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
   ${HOST_IP}:${HOST_PORT}/api/tasks \
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
   --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
   --header "X-CSRFToken: ${CSRF_TOKEN}" \
   ${HOST_IP}:${HOST_PORT}/api/tasks/3 \
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
   ${HOST_IP}:${HOST_PORT}/api/tasks/3 \
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
   --header "Cookie: sessionid=${SESSION_ID}; csrftoken=${CSRF_TOKEN}" \
   --header "X-CSRFToken: ${CSRF_TOKEN}" \
   ${HOST_IP}:${HOST_PORT}/api/tasks/2

# # ...
# < HTTP/1.1 204 No Content
# # ...
# <no output>
# ```
