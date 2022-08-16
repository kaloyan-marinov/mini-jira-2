using `localhost` (= the local network interface) to serve the Django application:

```
$ python3 --version
Python 3.8.3

$ python3 -m venv venv
$ source venv/bin/activate
(venv) $ pip install --upgrade pip
(venv) $ pip install -r requirements.txt
```

```
(venv) $ python manage.py migrate
```

```
# Launch one terminal instance and, in it, start serving the application:

(venv) $ python manage.py runserver
```

```
# Launch a second terminal instance and, in it, issue requests to the application:

~ $ http localhost:8000/projects

HTTP/1.1 200 OK
Content-Length: 2
Content-Type: application/json
Cross-Origin-Opener-Policy: same-origin
Date: Tue, 16 Aug 2022 05:41:06 GMT
Referrer-Policy: same-origin
Server: WSGIServer/0.2 CPython/3.8.3
X-Content-Type-Options: nosniff
X-Frame-Options: DENY

[]


~ $ http POST \
    localhost:8000/projects \
    name="Create a Springboot app"

HTTP/1.1 200 OK
Content-Length: 87
Content-Type: application/json
Cross-Origin-Opener-Policy: same-origin
Date: Tue, 16 Aug 2022 05:41:45 GMT
Referrer-Policy: same-origin
Server: WSGIServer/0.2 CPython/3.8.3
X-Content-Type-Options: nosniff
X-Frame-Options: DENY

[
    {
        "fields": {
            "name": "Create a Springboot app"
        },
        "model": "projects.project",
        "pk": 1
    }
]


~ $ http POST \
    localhost:8000/projects \
    name="Create a Django app"

HTTP/1.1 200 OK
Content-Length: 83
Content-Type: application/json
Cross-Origin-Opener-Policy: same-origin
Date: Tue, 16 Aug 2022 05:41:48 GMT
Referrer-Policy: same-origin
Server: WSGIServer/0.2 CPython/3.8.3
X-Content-Type-Options: nosniff
X-Frame-Options: DENY

[
    {
        "fields": {
            "name": "Create a Django app"
        },
        "model": "projects.project",
        "pk": 2
    }
]


~ $ http localhost:8000/projects

HTTP/1.1 200 OK
Content-Length: 170
Content-Type: application/json
Cross-Origin-Opener-Policy: same-origin
Date: Tue, 16 Aug 2022 05:41:53 GMT
Referrer-Policy: same-origin
Server: WSGIServer/0.2 CPython/3.8.3
X-Content-Type-Options: nosniff
X-Frame-Options: DENY

[
    {
        "fields": {
            "name": "Create a Springboot app"
        },
        "model": "projects.project",
        "pk": 1
    },
    {
        "fields": {
            "name": "Create a Django app"
        },
        "model": "projects.project",
        "pk": 2
    }
]


~ $ http DELETE \
    localhost:8000/projects/1

HTTP/1.1 200 OK
Content-Length: 83
Content-Type: application/json
Cross-Origin-Opener-Policy: same-origin
Date: Tue, 16 Aug 2022 05:42:01 GMT
Referrer-Policy: same-origin
Server: WSGIServer/0.2 CPython/3.8.3
X-Content-Type-Options: nosniff
X-Frame-Options: DENY

[
    {
        "fields": {
            "name": "Create a Django app"
        },
        "model": "projects.project",
        "pk": 2
    }
]


~ $ http localhost:8000/projects

HTTP/1.1 200 OK
Content-Length: 83
Content-Type: application/json
Cross-Origin-Opener-Policy: same-origin
Date: Tue, 16 Aug 2022 05:42:03 GMT
Referrer-Policy: same-origin
Server: WSGIServer/0.2 CPython/3.8.3
X-Content-Type-Options: nosniff
X-Frame-Options: DENY

[
    {
        "fields": {
            "name": "Create a Django app"
        },
        "model": "projects.project",
        "pk": 2
    }
]


~ $ http PUT \
    localhost:8000/projects/2 \
    name="Build a Django app"

HTTP/1.1 200 OK
Content-Length: 82
Content-Type: application/json
Cross-Origin-Opener-Policy: same-origin
Date: Tue, 16 Aug 2022 05:45:55 GMT
Referrer-Policy: same-origin
Server: WSGIServer/0.2 CPython/3.8.3
X-Content-Type-Options: nosniff
X-Frame-Options: DENY

[
    {
        "fields": {
            "name": "Build a Django app"
        },
        "model": "projects.project",
        "pk": 2
    }
]


~ $ http localhost:8000/projects

HTTP/1.1 200 OK
Content-Length: 82
Content-Type: application/json
Cross-Origin-Opener-Policy: same-origin
Date: Tue, 16 Aug 2022 05:45:59 GMT
Referrer-Policy: same-origin
Server: WSGIServer/0.2 CPython/3.8.3
X-Content-Type-Options: nosniff
X-Frame-Options: DENY

[
    {
        "fields": {
            "name": "Build a Django app"
        },
        "model": "projects.project",
        "pk": 2
    }
]
```