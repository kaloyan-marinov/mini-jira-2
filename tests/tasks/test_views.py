import os
import pytest

from django.conf import settings
from django.test import Client

# fmt: off
'''
If the code-block that follows this comment is removed,
then using the "Testing" panel in VS Code to run the test suite would crash with
```
E           django.core.exceptions.ImproperlyConfigured: Requested setting DEFAULT_CHARSET, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.

venv/lib/python3.8/site-packages/django/conf/__init__.py:82: ImproperlyConfigured
=========================== short test summary info ============================
FAILED tests/tasks/test_views.py::test_get_tasks - django.core.exceptions.Imp...
========================= 1 failed, 2 passed in 1.49s ==========================
```


The reason for that crash is as described by
the following except from
https://docs.djangoproject.com/en/4.2/topics/settings/ :

A settings file [for a Django project]
is just a Python module with module-level variables.

...

When you use Django, you have to tell it which settings you're using.
Do this by using an environment variable, `DJANGO_SETTINGS_MODULE`.

...

If you're not setting the `DJANGO_SETTINGS_MODULE` environment variable,
you must call `configure()` at some point before using any code that reads settings.

...

If you're using components of Django “standalone” -
for example, writing a Python script which loads some Django templates and renders them,
or uses the ORM to fetch some data -
there's one more step you'll need in addition to configuring settings.

After you've either set `DJANGO_SETTINGS_MODULE` or called `configure()`,
you'll need to call `django.setup()`
to load your settings and populate Django's application registry.



The approach described in the excerpt above
is implemented by
the code-block that follows this comment.
'''
# fmt: on
os.environ["DJANGO_SETTINGS_MODULE"] = "src.mini_jira_2.settings"
import django

# TODO: (2023/12/15, 09:10)
#       The following achieves an overriding of the web application's settings
#       at runtime (= i.e. when the test suite is executed).
#       Consider re-factoring the way in which the overriding is achieved;
#       alternative approaches are hinted at in the following resources:
#           https://gdevops.gitlab.io/django/tuto/tests/pytest_django/test_database/test_database.html
#           https://pytest-django.readthedocs.io/en/latest/database.html#django-db-modify-db-settings
settings.DATABASES["default"] = {
    "ENGINE": "django.db.backends.sqlite3",
}

django.setup()
# fmt: on

from src.tasks.models import Task
from django.contrib.auth.models import User


@pytest.mark.django_db
def test_process_tasks_1_post():
    """
    If the request body contains values for each of 'category' and 'description',
    then a new `Task` should be created successfully.
    """

    # Arrange.
    username = "test-jd"
    email = "test-john.doe@protonmai.com"
    password = "test-123"
    user = User.objects.create_user(
        username,
        email=email,
        password=password,
    )

    client = Client()

    # Similarly to [this documentation](
    #   https://docs.djangoproject.com/en/5.0/topics/testing/tools/#django.test.Client.login
    # ) about `client.login`,
    # invoking the next statement causes the test `client`
    # to have all the cookies and session data
    # required to pass any(?) [login-required checks] that may [be] part of a view [function].
    response_ = client.post(
        "/api/sign_in",
        data={
            "username": user.username,
            "password": password,
        },
    )
    csrf_token = response_.cookies["csrftoken"].value
    session_id = response_.cookies["sessionid"].value

    # from django.contrib.sessions.backends.db import SessionStore
    # from django.contrib.sessions.models import Session

    # client_session = Session.objects.get(
    #     pk=client.session.session_key,
    # )

    # client_cookies = client.cookies

    # As per [this](
    #   https://stackoverflow.com/questions/19616817/testing-django-application-cookies-sessions-and-states
    # ),
    # the following statement should not be used in this test:
    # fmt: off
    '''
    client.logout()
    '''
    # fmt: on

    # Act.
    response = client.post(
        "/api/tasks",
        data={
            "category": "health",
            "description": "go to the doctor",
        },
        # # fmt: off
        # '''
        # # https://stackoverflow.com/questions/26639169/csrf-failed-csrf-token-missing-or-incorrect/26639895#26639895
        # headers={
        #     "Cookie": f"sessionid={session_id}; csrftoken={csrf_token};",
        # },
        # '''
        # # fmt: on
    )

    # Assert.
    assert response.status_code == 201
    assert response.json() == {
        "id": 1,
        "category": "health",
        "description": "go to the doctor",
    }


@pytest.mark.django_db
def test_process_tasks_2_get(admin_client):
    """
    If no `Task`s have been created,
    then getting all `Task`s should return an empty list.
    """

    # Arrange.
    client = Client()

    # Act.
    response = admin_client.get("/api/tasks")

    # Assert.
    assert response.status_code == 200
    assert response.json() == {
        "items": [],
    }


@pytest.mark.django_db
def test_process_tasks_3_get(admin_client):
    """
    If `Task`s have been created,
    then getting all `Task`s should return
    a list containing representations of all `Task`s.
    """

    # Arrange.
    client = Client()

    _ = admin_client.post(
        "/api/tasks",
        data={
            "category": "health",
            "description": "go to the doctor",
        },
    )

    _ = admin_client.post(
        "/api/tasks",
        data={
            "category": "work",
            "description": "build a web application using Django",
        },
    )

    # Act.
    response = admin_client.get("/api/tasks")

    # Assert.
    assert response.status_code == 200
    assert response.json() == {
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
        ]
    }


@pytest.mark.django_db
def test_process_task_1_get(admin_client):
    """
    Requesting to retrieve an existing `Task`
    should return a representation of that `Task`.
    """

    # Arrange.
    client = Client()

    _ = admin_client.post(
        "/api/tasks",
        data={
            "category": "health",
            "description": "go to the doctor",
        },
    )

    # Act.
    response = admin_client.get("/api/tasks/1")

    # Assert.
    assert response.status_code == 200
    assert response.json() == {
        "id": 1,
        "category": "health",
        "description": "go to the doctor",
    }


@pytest.mark.django_db
def test_process_task_2_put(admin_client):
    # Arrange.
    client = Client()

    _ = admin_client.post(
        "/api/tasks",
        data={
            "category": "helthh",
            "description": "go to the dctr",
        },
    )

    # Act.
    response = admin_client.put(
        "/api/tasks/1",
        data={
            "category": "health",
            "description": "go to the doctor",
        },
        content_type="application/json",
    )

    # Assert.
    assert response.status_code == 200
    assert response.json() == {
        "id": 1,
        "category": "health",
        "description": "go to the doctor",
    }

    e = Task.objects.get(id=1)
    assert e.category == "health"
    assert e.description == "go to the doctor"


@pytest.mark.django_db
def test_process_task_3_delete(admin_client):
    # Arrange.
    client = Client()

    _ = admin_client.post(
        "/api/tasks",
        data={
            "category": "health",
            "description": "go to the doctor",
        },
    )

    # Act.
    response = admin_client.delete("/api/tasks/1")

    # Assert.
    assert response.status_code == 204

    assert Task.objects.count() == 0
