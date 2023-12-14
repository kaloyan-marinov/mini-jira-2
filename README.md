![run-test-suite](https://github.com/kaloyan-marinov/mini-jira-2/actions/workflows/run-test-suite.yml/badge.svg)

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
    --cov-report=term-missing \
    --cov-branch

============================= test session starts ==============================
platform darwin -- Python 3.8.3, pytest-7.4.3, pluggy-1.3.0
rootdir: /Users/is4e1pmmt/Documents/repos/mini-jira-2
plugins: cov-4.1.0, django-4.7.0
collected 6 items                                                                                                                                                                

tests/tasks/test_views.py ......                                                                                                                                           [100%]

---------- coverage: platform darwin, python 3.8.3-final-0 -----------
Name                                   Stmts   Miss Branch BrPart  Cover   Missing
----------------------------------------------------------------------------------
src/manage.py                             12     12      2      0     0%   2-22
src/mini_jira_2/__init__.py                0      0      0      0   100%
src/mini_jira_2/asgi.py                    4      4      0      0     0%   10-16
src/mini_jira_2/settings.py               21      0      0      0   100%
src/mini_jira_2/urls.py                    3      0      0      0   100%
src/mini_jira_2/wsgi.py                    4      4      0      0     0%   10-16
src/tasks/__init__.py                      0      0      0      0   100%
src/tasks/admin.py                         1      0      0      0   100%
src/tasks/apps.py                          4      0      0      0   100%
src/tasks/migrations/0001_initial.py       5      0      0      0   100%
src/tasks/migrations/__init__.py           0      0      0      0   100%
src/tasks/models.py                        4      0      0      0   100%
src/tasks/tests.py                         1      1      0      0     0%   1
src/tasks/urls.py                          3      0      0      0   100%
src/tasks/views.py                        35      1     18      5    89%   27, 37->exit, 67->70, 71->74, 84->exit
----------------------------------------------------------------------------------
TOTAL                                     97     22     20      5    75%


============================== 6 passed in 4.06s ===============================
```

Run an individual test case:
```bash
(venv) $ PYTHONPATH=. pytest \
   tests/tasks/test_views.py::test_process_tasks_1_post
# ...
```

# Launch the project

This section explain how to
use a container engine (such as Podman, Docker, etc.) to serve the persistence layer,
but use `localhost` (= the local network interface) to serve the Django application.

```bash
# If the container engine that you wish to use is Podman,
# executing this command will allow you to simply copy-and-paste
# each of the subsequent commands that deal with containerization.
# 
# This step:
#  (a) is only applicable if the container engine you wish to use is Podman;
#  (b) is only a matter of convenience and, as such, is completely optional.
alias docker=podman
```

```bash
# Launch one terminal instance and, in it, start serving the persistence layer:
docker run \
    --name container-m-j-2-postgres \
    --mount type=volume,source=volume-m-j-2-postgres,destination=/var/lib/postgresql/data \
    --env-file .env \
    --publish 5432:5432 \
    postgres:15.1
```

(

OPTIONALLY, verify that the previous step did start serving a PostgreSQL server:

```bash
$ docker container exec \
   -it \
   container-m-j-2-postgres \
   /bin/bash
root@<container-id> psql \
    --host=localhost \
    --port=5432 \
    --username=<the-value-for-POSTGRES_USER-in-the-.env-file> \
    --password \
    <the-value-for-POSTGRES_DB-in-the-.env-file>

Password: 
psql (15.1 (Debian 15.1-1.pgdg110+1))
Type "help" for help.

<the-value-for-POSTGRES_DB-in-the-.env-file>=# \d
Did not find any relations.
```

)

```bash
# Launch a second terminal instance and, in it, do the following:

# (a) apply the database migrations:
(venv) $ PYTHONPATH=. python src/manage.py migrate

# (b) optionally, verify that the database migrations were applied successfully:
(venv) $ docker container exec \
   -it \
   container-m-j-2-postgres \
   /bin/bash
root@<container-id> psql \
    --host=localhost \
    --port=5432 \
    --username=<the-value-for-POSTGRES_USER-in-the-.env-file> \
    --password \
    <the-value-for-POSTGRES_DB-in-the-.env-file>

Password: 
psql (15.1 (Debian 15.1-1.pgdg110+1))
Type "help" for help.

<the-value-for-POSTGRES_DB-in-the-.env-file>=# \d
                        List of relations
 Schema |               Name                |   Type   |  Owner  
--------+-----------------------------------+----------+---------
 public | auth_group                        | table    | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | auth_group_id_seq                 | sequence | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | auth_group_permissions            | table    | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | auth_group_permissions_id_seq     | sequence | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | auth_permission                   | table    | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | auth_permission_id_seq            | sequence | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | auth_user                         | table    | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | auth_user_groups                  | table    | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | auth_user_groups_id_seq           | sequence | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | auth_user_id_seq                  | sequence | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | auth_user_user_permissions        | table    | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | auth_user_user_permissions_id_seq | sequence | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | django_admin_log                  | table    | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | django_admin_log_id_seq           | sequence | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | django_content_type               | table    | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | django_content_type_id_seq        | sequence | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | django_migrations                 | table    | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | django_migrations_id_seq          | sequence | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | django_session                    | table    | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | tasks_task                        | table    | <the-value-for-POSTGRES_USER-in-the-.env-file>
 public | tasks_task_id_seq                 | sequence | <the-value-for-POSTGRES_USER-in-the-.env-file>
(21 rows)
        
<the-value-for-POSTGRES_DB-in-the-.env-file>=# \d tasks_task
                                   Table "public.tasks_task"
   Column    |          Type          | Collation | Nullable |             Default              
-------------+------------------------+-----------+----------+----------------------------------
 id          | bigint                 |           | not null | generated by default as identity
 category    | character varying(64)  |           | not null | 
 description | character varying(256) |           | not null | 
Indexes:
    "tasks_task_pkey" PRIMARY KEY, btree (id)
    "tasks_task_category_200000de_like" btree (category varchar_pattern_ops)
    "tasks_task_category_key" UNIQUE CONSTRAINT, btree (category)

<the-value-for-POSTGRES_DB-in-the-.env-file>=# SELECT * FROM tasks_task;                                                                                                                                                                                             
 id | category | description 
----+----------+-------------
(0 rows)
```

```bash
# Launch a third terminal instance and, in it, start serving the application:
(venv) $ PYTHONPATH=. python src/manage.py runserver
```

```bash
# Launch a fourth terminal instance and, in it, issue requests to the application:

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
