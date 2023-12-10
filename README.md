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
(venv) $ PYTHONPATH=. pytest
```

Run an individual test case:
```bash
(venv) $ PYTHONPATH=. pytest tests/test_utilities_temp.py::test_add_1
# ...
```
