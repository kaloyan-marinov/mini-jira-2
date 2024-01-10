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

tests/tasks/test_views.py ......                                                                                                                                   [100%]

---------- coverage: platform darwin, python 3.8.3-final-0 -----------
Name                                   Stmts   Miss Branch BrPart  Cover   Missing
----------------------------------------------------------------------------------
src/manage.py                             12     12      2      0     0%   2-22
src/mini_jira_2/__init__.py                0      0      0      0   100%
src/mini_jira_2/asgi.py                    4      4      0      0     0%   10-16
src/mini_jira_2/settings.py               28      2      2      1    90%   94-95
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
TOTAL                                    104     24     22      6    75%


============================== 6 passed in 4.06s ===============================
```

Run a single class of test cases:
```bash
(venv) $ PYTHONPATH=. pytest \
   tests/tasks/test_views.py::Test_1_ProcessTasks
# ...
```

Run an individual test case:
```bash
(venv) $ PYTHONPATH=. pytest \
   tests/tasks/test_views.py::Test_1_ProcessTasks::test_post
# ...
```

# Launch the project

This section explain how to
use a container engine (such as Podman, Docker, etc.) to serve the persistence layer,
but use `localhost` (= the local network interface) to serve the web application.

(

If the container engine that you wish to use is Docker,
you "should" be use each of the following commands
by simply replacing `podman` with `docker` in each command.

The reason for the quotation marks in "shoud" is that
the commands in question are
<ins>actively monitored-and-controlled for correctness</ins>
only with the `podman` executable.

)

```bash
# Launch one terminal instance and, in it, start serving the persistence layer:
podman volume create volume-mini-jira-2-postgres

podman run \
    --name container-mini-jira-2-postgres \
    --mount type=volume,source=volume-mini-jira-2-postgres,destination=/var/lib/postgresql/data \
    --env-file .env \
    --publish 5432:5432 \
    postgres:15.1
```

(

OPTIONALLY, verify that the previous step did start serving a PostgreSQL server:

```bash
$ podman container exec \
   -it \
   container-mini-jira-2-postgres \
   /bin/bash
root@<container-id> psql \
    --host=localhost \
    --port=5432 \
    --username=<the-value-for-POSTGRES_USER-in-the-.env-file> \
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
(venv) $ podman container exec \
   -it \
   container-m-j-2-postgres \
   /bin/bash
root@<container-id> psql \
    --host=localhost \
    --port=5432 \
    --username=<the-value-for-POSTGRES_USER-in-the-.env-file> \
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
# Provide the values of `USERNAME`, `EMAIL`, `PASSWORD`
# from the `.env` file.
(venv) $ PYTHONPATH=. python src/manage.py shell
Python 3.8.3 (v3.8.3:6f8c8320e9, May 13 2020, 16:29:34) 
[Clang 6.0 (clang-600.0.57)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
(InteractiveConsole)
>>> import os
>>> from django.contrib.auth.models import User
>>> user = User.objects.create_user(
    os.environ.get("USERNAME"),
    os.environ.get("EMAIL"),
    os.environ.get("PASSWORD"),
)
>>> exit()
```

```bash
# Launch a third terminal instance and, in it, start serving the application:
(venv) $ PYTHONPATH=. python src/manage.py runserver
```

```bash
# Launch a fourth terminal instance and, in it, issue requests to the application
# either by running the utility script:
$ HOST_IP=localhost \
   HOST_PORT=8000 \
   utility-scripts/populate-db.sh
# or by copying the commands from that script and executing them
# one-by-one and in the same order as they appear in inside the script.
```

# How to run a containerized version of the project

```bash
$ podman network create network-mini-jira-2
```

```bash
$ podman volume create volume-mini-jira-2-postgres

$ DB_ENGINE_HOST=mini-jira-2-database-server bash -c '
   podman run \
      --name container-mini-jira-2-postgres \
      --network network-mini-jira-2 \
      --network-alias ${DB_ENGINE_HOST} \
      --mount type=volume,source=volume-mini-jira-2-postgres,destination=/var/lib/postgresql/data \
      --env-file=.env \
      --env 'DB_ENGINE_HOST' \
      --detach \
      postgres:15.1 \
   '
```

```bash
$ export HYPHENATED_YYYY_MM_DD_HH_MM=2024-01-01-10-35
```

```bash
mini-jira-2 $ podman build \
   --file Containerfile \
   --tag image-mini-jira-2:${HYPHENATED_YYYY_MM_DD_HH_MM} \
   .

$ DB_ENGINE_HOST=mini-jira-2-database-server bash -c '
   podman run \
      --name container-mini-jira-2 \
      --network network-mini-jira-2 \
      --network-alias mini-jira-2-web-application \
      --env-file .env \
      --env 'DB_ENGINE_HOST' \
      --publish 8000:5000 \
      --detach \
      image-mini-jira-2:${HYPHENATED_YYYY_MM_DD_HH_MM} \
   '

# Launch another terminal instance
# and, in it:
# (a) Provide the values of `USERNAME`, `EMAIL`, `PASSWORD`
#     from the `.env` file.
$ podman container exec \
   -it \
   container-mini-jira-2 \
   /bin/bash

root@<container-id> python src/manage.py shell
Python 3.8.3 (v3.8.3:6f8c8320e9, May 13 2020, 16:29:34) 
[Clang 6.0 (clang-600.0.57)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
(InteractiveConsole)
>>> import os
>>> from django.contrib.auth.models import User
>>> user = User.objects.create_user(
    os.environ.get("USERNAME"),
    os.environ.get("EMAIL"),
    os.environ.get("PASSWORD"),
)
>>> exit()
```

```bash
# (b) Issue requests to the web application.
$ HOST_IP=localhost \
   HOST_PORT=8000 \
   utility-scripts/populate-db.sh

# Stop running all containers,
# remove the created volume,
# and remove the created network
# by issuing:
$ utility-scripts/clean-container-artifacts.sh
```

# How to run a containerized version of the project via Kubernetes

install `docker`

install `minikube`
which also installs the `kubectl` command-line tool (as a dependency)

```bash
$ minikube start --driver docker

# Check the status of the cluster.
$ minikube status

minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

install the Kubernetes command-line tool, `kubectl`,
which allows you to run commands against Kubernetes clusters

```bash
# Display all nodes in the cluster.
$ kubectl get node

NAME       STATUS   ROLES           AGE     VERSION
minikube   Ready    control-plane   7m42s   v1.28.3
```

```bash
$ minikube image ls \
   --format table
|-----------------------------------------|---------|---------------|--------|
|                  Image                  |   Tag   |   Image ID    |  Size  |
|-----------------------------------------|---------|---------------|--------|
| registry.k8s.io/kube-scheduler          | v1.28.3 | 6d1b4fd1b182d | 60.1MB |
| registry.k8s.io/coredns/coredns         | v1.10.1 | ead0a4a53df89 | 53.6MB |
| registry.k8s.io/kube-apiserver          | v1.28.3 | 5374347291230 | 126MB  |
| registry.k8s.io/kube-controller-manager | v1.28.3 | 10baa1ca17068 | 122MB  |
| registry.k8s.io/kube-proxy              | v1.28.3 | bfc896cf80fba | 73.1MB |
| registry.k8s.io/etcd                    | 3.5.9-0 | 73deb9a3f7025 | 294MB  |
| docker.io/library/postgres              | 15.1    | ccd94e8b5fd9d | 379MB  |
| registry.k8s.io/pause                   | 3.9     | e6f1816883972 | 744kB  |
| gcr.io/k8s-minikube/storage-provisioner | v5      | 6e38f40d628db | 31.5MB |
|-----------------------------------------|---------|---------------|--------|

# As per Step 5 in https://www.baeldung.com/docker-local-images-minikube ,
# build an image inside Minikube.
$ minikube image build \
   --file Containerfile \
   --tag image-mini-jira-2:${HYPHENATED_YYYY_MM_DD_HH_MM} \
   .

$ minikube image ls \
   --format table
|-----------------------------------------|------------------|---------------|--------|
|                  Image                  |       Tag        |   Image ID    |  Size  |
|-----------------------------------------|------------------|---------------|--------|
| registry.k8s.io/pause                   | 3.9              | e6f1816883972 | 744kB  |
| docker.io/library/image-mini-jira-2     | 2024-01-01-10-35 | 7dcd8b78252a4 | 202MB  |
| registry.k8s.io/kube-apiserver          | v1.28.3          | 5374347291230 | 126MB  |
| registry.k8s.io/kube-proxy              | v1.28.3          | bfc896cf80fba | 73.1MB |
| registry.k8s.io/etcd                    | 3.5.9-0          | 73deb9a3f7025 | 294MB  |
| docker.io/library/postgres              | 15.1             | ccd94e8b5fd9d | 379MB  |
| registry.k8s.io/coredns/coredns         | v1.10.1          | ead0a4a53df89 | 53.6MB |
| gcr.io/k8s-minikube/storage-provisioner | v5               | 6e38f40d628db | 31.5MB |
| registry.k8s.io/kube-scheduler          | v1.28.3          | 6d1b4fd1b182d | 60.1MB |
| registry.k8s.io/kube-controller-manager | v1.28.3          | 10baa1ca17068 | 122MB  |
|-----------------------------------------|------------------|---------------|--------|
```

Create all Kubernetes components
(= a complete containerized version of this project within a Kubernetes cluster):

```bash
$ kubectl apply \
   --filename=kubernetes/database/postgres-config.yaml

$ kubectl create secret \
   generic \
   postgres-secret \
   --from-literal=postgres-db=<the-value-for-POSTGRES_DB-in-the-.env-file> \
   --from-literal=postgres-user=<the-value-for-POSTGRES_USER-in-the-.env-file> \
   --from-literal=postgres-password=<the-value-for-POSTGRES_PASSWORD-in-the-.env-file>

$ kubectl apply \
   --filename=kubernetes/database/postgres.yaml

$ kubectl create secret \
   generic \
   webapp-secret \
   --from-literal=django-secret-key=<the-value-for-DJANGO_SECRET_KEY-in-the-.env-file>

$ kubectl apply \
   --filename=kubernetes/application/webapp.yaml
```

List all Kubernetes components that were created in the previous step
(and inspect the (internal) details of some of those components):

```bash
$ kubectl get all
NAME                                       READY   STATUS    RESTARTS   AGE
pod/postgres-deployment-6db565b94d-2c76d   1/1     Running   0          26s
pod/webapp-deployment-85c9ddc-d5tnc        1/1     Running   0          4s

NAME                       TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
service/kubernetes         ClusterIP   10.96.0.1      <none>        443/TCP          4m13s
service/postgres-service   ClusterIP   10.103.6.209   <none>        5432/TCP         26s
service/webapp-service     NodePort    10.97.27.140   <none>        5000:30100/TCP   4s

NAME                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/postgres-deployment   1/1     1            1           26s
deployment.apps/webapp-deployment     1/1     1            1           4s

NAME                                             DESIRED   CURRENT   READY   AGE
replicaset.apps/postgres-deployment-6db565b94d   1         1         1       26s
replicaset.apps/webapp-deployment-85c9ddc        1         1         1       4s

$ kubectl get configmap
NAME               DATA   AGE
kube-root-ca.crt   1      4m5s
postgres-config    2      2m47s

$ kubectl get secret
NAME              TYPE     DATA   AGE
postgres-secret   Opaque   3      100s
webapp-secret     Opaque   1      72s



$ kubectl describe service webapp-service
Name:                     webapp-service
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 app=webapp
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.97.27.140
IPs:                      10.97.27.140
Port:                     <unset>  5000/TCP
TargetPort:               5000/TCP
NodePort:                 <unset>  30100/TCP
Endpoints:                10.244.0.37:5000
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>

$ kubectl describe pod webapp-deployment-85c9ddc-d5tnc
Name:             webapp-deployment-85c9ddc-d5tnc
Namespace:        default
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Tue, 09 Jan 2024 05:40:46 +0000
Labels:           app=webapp
                  pod-template-hash=85c9ddc
Annotations:      <none>
Status:           Running
IP:               10.244.0.37
IPs:
  IP:           10.244.0.37
Controlled By:  ReplicaSet/webapp-deployment-85c9ddc
Containers:
  container-mini-jira-2-webapp:
    Container ID:   docker://56d8e6d70f3c827ce2d37fdccd5dfd699745a283c85b3da0260de3e687347dda
    Image:          image-mini-jira-2:2024-01-01-10-35
    Image ID:       docker://sha256:7ccdc014450030fb780859b994d6121c636038932e55d55149c303fc9ca139e2
    Port:           5000/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Tue, 09 Jan 2024 05:40:48 +0000
    Ready:          True
    Restart Count:  0
    Environment:
      HOST_IP:             (v1:status.hostIP)
      DJANGO_SECRET_KEY:  <set to the key 'django-secret-key' in secret 'webapp-secret'>     Optional: false
      DB_ENGINE_HOST:     <set to the key 'db-engine-host' of config map 'postgres-config'>  Optional: false
      DB_ENGINE_PORT:     <set to the key 'db-engine-port' of config map 'postgres-config'>  Optional: false
      POSTGRES_DB:        <set to the key 'postgres-db' in secret 'postgres-secret'>         Optional: false
      POSTGRES_USER:      <set to the key 'postgres-user' in secret 'postgres-secret'>       Optional: false
      POSTGRES_PASSWORD:  <set to the key 'postgres-password' in secret 'postgres-secret'>   Optional: false
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-5lg9z (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-5lg9z:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  3m19s  default-scheduler  Successfully assigned default/webapp-deployment-85c9ddc-d5tnc to minikube
  Normal  Pulled     3m19s  kubelet            Container image "image-mini-jira-2:2024-01-01-10-35" already present on machine
  Normal  Created    3m18s  kubelet            Created container container-mini-jira-2-webapp
  Normal  Started    3m18s  kubelet            Started container container-mini-jira-2-webapp


$ kubectl logs --follow webapp-deployment-85c9ddc-d5tnc
```

Create a user in the `auth_user` table in the database
(by utilizing the Django model called `User`):

```bash
$ kubectl exec \
   webapp-deployment-85c9ddc-d5tnc \
   --container container-mini-jira-2-webapp \
   -it \
   -- \
   /bin/bash

root@webapp-deployment-85c9ddc-d5tnc:/# python src/manage.py shell

Python 3.8.18 (default, Dec 19 2023, 04:02:50) 
[GCC 12.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
(InteractiveConsole)
>>> import os
>>> from django.contrib.auth.models import User
>>> # Define a variable called `username` and
    # set it equal to the value of `USERNAME` from the `.env` file.
>>> # Define a variable called `email` and
    # set it equal to the value of `EMAIL` from the `.env` file.
>>> # Define a variable called `password` and
    # set it equal to the value of `PASSWORD` from the `.env` file.
>>> user = User.objects.create_user(
       username,
       email,
       password,
    )
>>> User.objects.all()
<QuerySet [<User: <the-value-for-USERNAME-in-the-.env-file>]>
>>> exit()

root@webapp-deployment-85c9ddc-d5tnc:/# exit
```

Execute the `utility-scripts/populate-db.sh` script:

```bash
# Determine the IP and port,
# which the `webapp-deployment-85c9ddc-d5tnc` pod can be accessed at from localhost.
# (That can be achieved by issuing either one of the commands below.)
$ kubectl describe pod \
   webapp-deployment-85c9ddc-d5tnc \
   | grep 'Node:'
Node:             minikube/192.168.49.2

$ minikube ip
192.168.49.2

# Note that the value, which should be assigned to `HOST_PORT`, can be obtained
# either by issuing `grep 'nodePort:' kubernetes/application/webapp.yaml`
# or by issuing `kubectl get services | grep webapp-service`.
$ HOST_IP=$(minikube ip) \
   HOST_PORT=<the-value-of-the-nodePort-within-webapp.yaml> \
   utility-scripts/populate-db.sh
```

Tear down the setup created in this section:

```bash
$ kubectl delete pods --all

$ kubectl delete services --all

$ kubectl delete deployments --all

$ kubectl delete secrets --all

$ kubectl delete configmaps --all

$ minikube stop
```

# Future plans

- figure out how to avoid creating Kubernetes secret( component)s from the command line;
  more concretely, look into how HashiCorp Vault can be taken into use
  (for the purpose of managing sensitive data)
  as part of this project

- add a pod running Nginx to the (above-described) Kubernetes setup,
  and arrange for that Nginx pod to act as a load balancer within the Kubernetes setup

- make it possible
  to register/create a new `User` by issuing HTTP requests to the web application

- create a Django app called `frontend`
  that - by utilizing <ins>pure-Django</ins> session-based authentication! -
  allows users to use their web browsers
  in order to register, manage their passwords, log in, and log out
  (
  whereby the `SessionAuthentication`,
  which the Django REST Framework is configured to use,
  will "play nice" with the <ins>pure-Django</ins> session-based authentication
  )
