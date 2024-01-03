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
docker volume create volume-mini-jira-2-postgres

docker run \
    --name container-mini-jira-2-postgres \
    --mount type=volume,source=volume-mini-jira-2-postgres,destination=/var/lib/postgresql/data \
    --env-file .env \
    --publish 5432:5432 \
    postgres:15.1
```

(

OPTIONALLY, verify that the previous step did start serving a PostgreSQL server:

```bash
$ docker container exec \
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
$ utility-scripts/populate-db.sh
# or by copying the commands from that script and executing them
# one-by-one and in the same order as they appear in inside the script.
```

# How to run a containerized version of the project

```bash
$ docker network create network-mini-jira-2
```

```bash
$ docker volume create volume-mini-jira-2-postgres

$ DB_ENGINE_HOST=mini-jira-2-database-server bash -c '
   docker run \
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
mini-jira-2 $ docker build \
   --file Containerfile \
   --tag image-mini-jira-2:${HYPHENATED_YYYY_MM_DD_HH_MM} \
   .

$ DB_ENGINE_HOST=mini-jira-2-database-server bash -c '
   docker run \
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
$ docker container exec \
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
# (b) You may issue requests to the web application
#     in the way that is described at the end of the previous section.

# Stop running all containers,
# remove the created volume,
# and remove the created network
# by issuing:
$ utility-scripts/clean-container-artifacts.sh
```

# How to run a containerized version of the project via Kubernetes

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
$ echo -n ${POSTGRES_USER} | base64

$ echo -n ${POSTGRES_PASSWORD} | base64
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

$  minikube image build \
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

```bash
# A quick search for "" on the Internet leads to
#
#  (a) https://stackoverflow.com/questions/57167104/how-to-use-local-docker-image-in-kubernetes-via-kubectl
#  (b) https://dev.to/docker/creating-a-private-local-docker-registry-in-5-minutes-2dnl
#
# Based on the information in those resources,
# a follow-up search for "dockerhub registry:2 image" on the Internet leads to
#
#  (c) https://hub.docker.com/_/registry
#
#  (d) https://distribution.github.io/distribution/
#      https://distribution.github.io/distribution/about/
#      https://distribution.github.io/distribution/about/deploying/

# https://distribution.github.io/distribution/about/deploying/#run-a-local-registry
$ docker run \
   --detach \
   --publish 5000:5000 \
   --restart=always \
   --name container-registry \
   registry:2

# https://distribution.github.io/distribution/about/deploying/#copy-an-image-from-docker-hub-to-your-registry
# 1. issue the `docker build` command from earlier on in this documentation
# ...
# 2. create an additional tag for the existing image
$ docker tag \
   image-mini-jira-2:${HYPHENATED_YYYY_MM_DD_HH_MM}  \
   localhost:5000/image-mini-jira-2:${HYPHENATED_YYYY_MM_DD_HH_MM}
# 3. push the image to the local registry running at `localhost:5000`:
#    (instructs docker to contact the registry located at ...)
$ docker push localhost:5000/image-mini-jira-2:${HYPHENATED_YYYY_MM_DD_HH_MM}
$ curl -X GET http://localhost:5000/v2/_catalog | json_pp
# ...
{
   "repositories" : [
      "image-mini-jira-2"
   ]
}
$ curl -X GET http://localhost:5000/v2/image-mini-jira-2/tags/list | json_pp
# ...
{
   "name" : "image-mini-jira-2",
   "tags" : [
      "2024-01-01-10-35"
   ]
}
# 4. remove _both_ locally-cached images
#    so that, in the next step,
#    we can test pulling the image from the locally-running registry
#    (
#    this step does _not_ remove the image from locally-running registry
#    )
$ docker image rm \
   image-mini-jira-2:${HYPHENATED_YYYY_MM_DD_HH_MM} \
   localhost:5000/image-mini-jira-2:${HYPHENATED_YYYY_MM_DD_HH_MM}
# 5. pull the image from the locally-running registry
$ docker pull \
   localhost:5000/image-mini-jira-2:${HYPHENATED_YYYY_MM_DD_HH_MM}
```

```bash
$ kubectl apply \
   --filename=kubernetes/database/postgres-config.yaml

$ kubectl apply \
   --filename=kubernetes/database/postgres-secret.yaml

$ kubectl apply \
   --filename=kubernetes/database/postgres.yaml

$ kubectl apply \
   --filename=kubernetes/application/webapp.yaml
```

```bash
$ kubectl get all
NAME                                       READY   STATUS                       RESTARTS   AGE
pod/postgres-deployment-67db759cf6-vwzgh   0/1     CreateContainerConfigError   0          2m53s
pod/webapp-deployment-547ff6bf59-8f59b     0/1     ImagePullBackOff             0          30s

NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/kubernetes         ClusterIP   10.96.0.1       <none>        443/TCP          3h33m
service/postgres-service   ClusterIP   10.105.35.111   <none>        5432/TCP         4m11s
service/webapp-service     NodePort    10.96.91.146    <none>        5000:30100/TCP   63s

NAME                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/postgres-deployment   0/1     1            0           2m53s
deployment.apps/webapp-deployment     0/1     1            0           30s

NAME                                             DESIRED   CURRENT   READY   AGE
replicaset.apps/postgres-deployment-67db759cf6   1         1         0       2m53s
replicaset.apps/webapp-deployment-547ff6bf59     1         1         0       30s

$ kubectl get configmap
NAME               DATA   AGE
kube-root-ca.crt   1      3h34m
postgres-config    1      6m4s

$ kubectl get secret
NAME              TYPE     DATA   AGE
postgres-secret   Opaque   2      5m37s



$ kubectl describe service webapp-service
Name:                     webapp-service
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 app=webapp
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.96.91.146
IPs:                      10.96.91.146
Port:                     <unset>  5000/TCP
TargetPort:               5000/TCP
NodePort:                 <unset>  30100/TCP
Endpoints:                
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>

$ kubectl describe pod webapp-deployment-547ff6bf59-8f59b
Name:             webapp-deployment-547ff6bf59-8f59b
Namespace:        default
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Tue, 02 Jan 2024 19:09:53 +0000
Labels:           app=webapp
                  pod-template-hash=547ff6bf59
Annotations:      <none>
Status:           Pending
IP:               10.244.0.5
IPs:
  IP:           10.244.0.5
Controlled By:  ReplicaSet/webapp-deployment-547ff6bf59
Containers:
  container-mini-jira-2-webapp:
    Container ID:   
    Image:          image-mini-jira-2:2024-01-01-10-35
    Image ID:       
    Port:           5000/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       ImagePullBackOff
    Ready:          False
    Restart Count:  0
    Environment:
      POSTGRES_DB:        <set to the key 'postgres-url' of config map 'postgres-config'>   Optional: false
      POSTGRES_USER:      <set to the key 'postgres-user' in secret 'postgres-secret'>      Optional: false
      POSTGRES_PASSWORD:  <set to the key 'postgres-password' in secret 'postgres-secret'>  Optional: false
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-kg8ds (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  kube-api-access-kg8ds:
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
  Type     Reason     Age                    From               Message
  ----     ------     ----                   ----               -------
  Normal   Scheduled  5m30s                  default-scheduler  Successfully assigned default/webapp-deployment-547ff6bf59-8f59b to minikube
  Normal   Pulling    3m47s (x4 over 5m29s)  kubelet            Pulling image "image-mini-jira-2:2024-01-01-10-35"
  Warning  Failed     3m44s (x4 over 5m26s)  kubelet            Failed to pull image "image-mini-jira-2:2024-01-01-10-35": Error response from daemon: pull access denied for image-mini-jira-2, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
  Warning  Failed     3m44s (x4 over 5m26s)  kubelet            Error: ErrImagePull
  Warning  Failed     3m33s (x6 over 5m25s)  kubelet            Error: ImagePullBackOff
  Normal   BackOff    21s (x20 over 5m25s)   kubelet            Back-off pulling image "image-mini-jira-2:2024-01-01-10-35"


$ kubectl logs --follow webapp-deployment-547ff6bf59-8f59b
```

```bash
$ kubectl delete pods --all

$ kubectl delete services --all

$ kubectl delete deployments --all

$ minikube stop
```

# Future plans

- figure out how to avoid hardcoding the (`base64`-encoded) values
  within `kubernetes/database/postgres-secret.yaml`

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
