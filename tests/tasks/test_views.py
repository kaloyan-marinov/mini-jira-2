import os
import pytest

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

django.setup()
# fmt: on


@pytest.mark.django_db
def test_get_tasks():
    # Arrange.
    client = Client()

    # Act.
    response = client.get("/api/tasks")

    # Assert.
    assert response.status_code == 200
    assert response.json() == {
        "items": [],
    }
