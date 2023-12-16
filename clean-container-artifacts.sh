podman container rm -f \
    container-mini-jira-2-postgres \
    container-mini-jira-2

podman volume prune

podman network prune

podman image prune
