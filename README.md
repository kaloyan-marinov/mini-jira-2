# Introduction

`MiniJira` is a web application
that, as the name suggests, is a miniature version of Jira
(= the well-known issue-tracking software product developed by Atlassian).

The purpose of `MiniJira` is to facilitate
the planning, execution, and completion of projects.
Specifically, the emphasis is on projects owned and developed
by a single individual (or by a _small_ number of contributors).

The main principle undergirding the development of `MiniJira` is as follows:

> The web application shall avoid fancy features,
  but rather focus on _minimalism_
  that is _sufficient_ for ensuring _effective_ progress and completion of projects.

# Ensure that secrets/credentials are handled/managed with care (aka "protected")

```bash
$ cp \
   .env.template \
   .env
# Edit the content of `.env` as per the comments/instructions therein.
```

# Create a virtual environment

```bash
$ python3 --version
Python 3.8.3
$ python3 -m venv venv

$ source venv/bin/activate
(venv) $ pip install --upgrade pip
(venv) $ pip install -r requirements.txt
```

# Run the test suite

Run all test cases:
```bash
(venv) $ PYTHONPATH=. pytest \
    --cov=src/ \
    --cov-report=term-missing

============================= test session starts ==============================
platform darwin -- Python 3.8.3, pytest-7.4.3, pluggy-1.3.0
rootdir: /Users/is4e1pmmt/Documents/repos/mini-jira-2
plugins: cov-4.1.0, django-4.7.0
collected 6 items                                                                                                                                          

tests/tasks/test_views.py ......                                                                                                                     [100%]

---------- coverage: platform darwin, python 3.8.3-final-0 -----------
Name                                   Stmts   Miss  Cover   Missing
--------------------------------------------------------------------
src/manage.py                             12     12     0%   2-22
src/mini_jira_2/__init__.py                0      0   100%
src/mini_jira_2/asgi.py                    4      4     0%   10-16
src/mini_jira_2/settings.py               21      0   100%
src/mini_jira_2/urls.py                    3      0   100%
src/mini_jira_2/wsgi.py                    4      4     0%   10-16
src/tasks/__init__.py                      0      0   100%
src/tasks/admin.py                         1      0   100%
src/tasks/apps.py                          4      0   100%
src/tasks/migrations/0001_initial.py       5      0   100%
src/tasks/migrations/__init__.py           0      0   100%
src/tasks/models.py                        4      0   100%
src/tasks/tests.py                         1      1     0%   1
src/tasks/urls.py                          3      0   100%
src/tasks/views.py                        35      1    97%   27
--------------------------------------------------------------------
TOTAL                                     97     22    77%


============================== 6 passed in 4.06s ===============================
```

Run an individual test case:
```bash
(venv) $ PYTHONPATH=. pytest \
   tests/tasks/test_views.py::test_process_tasks_1_post
# ...
```

# Launch a process responsible for serving the web application

```bash
# Launch one terminal instance and, in it, start serving the application:
(venv) $ PYTHONPATH=. python src/manage.py migrate
(venv) $ ll src/db.sqlite3

(venv) $ PYTHONPATH=. python src/manage.py runserver
```

```bash
# Launch a second terminal instance and, in it, inspect the database:
$ sqlite3 src/db.sqlite3

sqlite> .mode columns
sqlite> .headers on

sqlite> .tables
auth_group                  django_admin_log          
auth_group_permissions      django_content_type       
auth_permission             django_migrations         
auth_user                   django_session            
auth_user_groups            tasks_task                
auth_user_user_permissions

```

```bash
# Launch a third terminal instance and, in it, issue requests to the application:

$ curl \
   --verbose \
   localhost:8000/api/tasks \
   | json_pp

# ...
< HTTP/1.1 200 OK
# ...
{
   "items" : []
}

$ curl \
   --verbose \
   --request POST \
   --header "Content-Type: application/json" \
   --data '{
      "category": "health"
   }' \
   localhost:8000/api/tasks \
   | json_pp

# ...
< HTTP/1.1 400 Bad Request
# ...
{
   "error" : "Bad Request",
   "message" : "The request body has to provide values for each of 'category' and 'description'."
}

$ curl \
   --verbose \
   --request POST \
   --header "Content-Type: application/json" \
   --data '{
      "category": "health",
      "description": "go to the doctor"
   }' \
   localhost:8000/api/tasks \
   | json_pp

# ...
< HTTP/1.1 201 Created
# ...
{
   "category" : "health",
   "description" : "go to the doctor",
   "id" : 1
}



$ curl \
   --verbose \
   --request POST \
   --header "Content-Type: application/json" \
   --data '{
      "category": "work",
      "description": "build a web application using Django"
   }' \
   localhost:8000/api/tasks \
   | json_pp

# ...
< HTTP/1.1 201 Created
# ...
{
   "category" : "work",
   "description" : "build a web application using Django",
   "id" : 2
}

$ curl localhost:8000/api/tasks \
   --verbose \
   | json_pp

# ...
< HTTP/1.1 200 OK
# ...
{
   "items" : [
      {
         "category" : "health",
         "description" : "go to the doctor",
         "id" : 1
      },
      {
         "category" : "work",
         "description" : "build a web application using Django",
         "id" : 2
      }
   ]
}



$ curl \
   --verbose \
   --request POST \
   --header "Content-Type: application/json" \
   --data '{
      "category": "vacaton",
      "description": "look up intresting towns in Sicly to visitt"
   }' \
   localhost:8000/api/tasks \
   | json_pp

# ...
< HTTP/1.1 201 Created
# ...
{
   "category" : "vacaton",
   "description" : "look up intresting towns in Sicly to visitt",
   "id" : 3
}

$ curl \
   --verbose \
   localhost:8000/api/tasks/3 \
   | json_pp

# ...
< HTTP/1.1 200 OK
# ...
{
   "category" : "vacaton",
   "description" : "look up intresting towns in Sicly to visitt",
   "id" : 3
}

$ curl \
   --verbose \
   --request PUT \
   --header "Content-Type: application/json" \
   --data '{
      "category": "vacation",
      "description": "look up interesting towns in Sicily to visit"
   }' \
   localhost:8000/api/tasks/3 \
   | json_pp

# ...
< HTTP/1.1 200 OK
# ...
{
   "category" : "vacation",
   "description" : "look up interesting towns in Sicily to visit",
   "id" : 3
}

$ curl \
   --verbose \
   --request DELETE \
   localhost:8000/api/tasks/2

# ...
< HTTP/1.1 204 No Content
# ...
<no output>
```
