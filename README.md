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

================================================================== test session starts ===================================================================
platform darwin -- Python 3.8.3, pytest-7.4.3, pluggy-1.3.0
rootdir: /Users/is4e1pmmt/Documents/repos/mini-jira-2
plugins: cov-4.1.0, django-4.7.0
collected 3 items                                                                                                                                        

tests/test_utilities_temp.py ..                                                                                                                    [ 66%]
tests/tasks/test_views.py .                                                                                                                        [100%]

---------- coverage: platform darwin, python 3.8.3-final-0 -----------
Name                               Stmts   Miss  Cover   Missing
----------------------------------------------------------------
src/manage.py                         12     12     0%   2-22
src/mini_jira_2/__init__.py            0      0   100%
src/mini_jira_2/asgi.py                4      4     0%   10-16
src/mini_jira_2/settings.py           18      0   100%
src/mini_jira_2/urls.py                3      0   100%
src/mini_jira_2/wsgi.py                4      4     0%   10-16
src/tasks/__init__.py                  0      0   100%
src/tasks/admin.py                     1      0   100%
src/tasks/apps.py                      4      0   100%
src/tasks/migrations/__init__.py       0      0   100%
src/tasks/models.py                    1      0   100%
src/tasks/tests.py                     1      1     0%   1
src/tasks/urls.py                      3      0   100%
src/tasks/views.py                     7      0   100%
src/utilities_temp.py                  4      1    75%   6
----------------------------------------------------------------
TOTAL                                 62     22    65%


=================================================================== 3 passed in 1.22s ====================================================================
```

Run an individual test case:
```bash
(venv) $ PYTHONPATH=. pytest \
   tests/tasks/test_views.py::test_get_tasks
# ...
```

# Launch a process responsible for serving the web application

```bash
# Launch one terminal instance and, in it, start serving the application:
(venv) $ PYTHONPATH=. python src/manage.py runserver
```

```bash
# Launch a second terminal instance and, in it, issue requests to the application:
$ curl localhost:8000/api/tasks \
    | json_pp

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--100   245  100   245    0     0   9306      0 --:--:-- --:--:-- --:--:-- 17500
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
      },
      {
         "category" : "vacation",
         "description" : "look up interesting towns in Sicily to visit",
         "id" : 3
      }
   ]
}
```
