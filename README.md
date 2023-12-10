```bash
$ python3 --version
Python 3.8.3
$ python3 -m venv venv

$ source venv/bin/activate
(venv) $ pip install --upgrade pip
(venv) $ pip install -r requirements.txt
```

Run all test cases:
```bash
(venv) $ PYTHONPATH=. pytest \
    --cov=src/ \
    --cov-report=term-missing

================================================================== test session starts ===================================================================
platform darwin -- Python 3.8.3, pytest-7.4.3, pluggy-1.3.0
rootdir: /Users/is4e1pmmt/Documents/repos/mini-jira-2
plugins: cov-4.1.0, django-4.7.0
collected 2 items                                                                                                                                        

tests/test_utilities_temp.py ..                                                                                                                    [100%]

---------- coverage: platform darwin, python 3.8.3-final-0 -----------
Name                               Stmts   Miss  Cover   Missing
----------------------------------------------------------------
src/manage.py                         12     12     0%   2-22
src/mini_jira_2/__init__.py            0      0   100%
src/mini_jira_2/asgi.py                4      4     0%   10-16
src/mini_jira_2/settings.py           18     18     0%   13-123
src/mini_jira_2/urls.py                3      3     0%   17-20
src/mini_jira_2/wsgi.py                4      4     0%   10-16
src/tasks/__init__.py                  0      0   100%
src/tasks/admin.py                     1      1     0%   1
src/tasks/apps.py                      4      4     0%   1-6
src/tasks/migrations/__init__.py       0      0   100%
src/tasks/models.py                    1      1     0%   1
src/tasks/tests.py                     1      1     0%   1
src/tasks/views.py                     1      1     0%   1
src/utilities_temp.py                  4      1    75%   6
----------------------------------------------------------------
TOTAL                                 53     50     6%


=================================================================== 2 passed in 0.25s ====================================================================
```

Run an individual test case:
```bash
(venv) $ PYTHONPATH=. pytest tests/test_utilities_temp.py::test_add_1
# ...
```
