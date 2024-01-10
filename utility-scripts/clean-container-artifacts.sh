podman container rm -f \
    container-mini-jira-2-postgres \
    container-mini-jira-2

podman volume rm \
    volume-mini-jira-2-postgres

podman network rm \
    network-mini-jira-2

podman image prune
