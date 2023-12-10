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

========================================================================= test session starts ==========================================================================
platform darwin -- Python 3.8.3, pytest-7.4.3, pluggy-1.3.0
rootdir: /Users/is4e1pmmt/Documents/repos/mini-jira-2
plugins: cov-4.1.0
collected 2 items                                                                                                                                                      

tests/test_utilities_temp.py ..                                                                                                                                  [100%]

---------- coverage: platform darwin, python 3.8.3-final-0 -----------
Name                    Stmts   Miss  Cover   Missing
-----------------------------------------------------
src/utilities_temp.py       4      1    75%   6
-----------------------------------------------------
TOTAL                       4      1    75%


========================================================================== 2 passed in 0.21s ===========================================================================
```

Run an individual test case:
```bash
(venv) $ PYTHONPATH=. pytest tests/test_utilities_temp.py::test_add_1
# ...
```
