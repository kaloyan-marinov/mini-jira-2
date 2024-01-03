docker container rm -f \
    container-mini-jira-2-postgres \
    container-mini-jira-2

docker volume prune

docker network prune

docker image prune
