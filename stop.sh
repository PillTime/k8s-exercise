#!/bin/sh


### VARS ###


TRUE=0
FALSE=1


### FUNCTIONS ###


ensure_cluster_exists() {
    k3d cluster list --verbose | grep -i exercise > /dev/null 2>&1
    case $? in
        0)
            return "$TRUE"
            ;;
        *)
            return "$FALSE"
            ;;
    esac
}

ensure_registry_exists() {
    k3d registry list --verbose | grep -i localhost > /dev/null 2>&1
    case $? in
        0)
            return "$TRUE"
            ;;
        *)
            return "$FALSE"
            ;;
    esac
}

delete_cluster() {
    k3d cluster delete exercise
}

delete_registry() {
    k3d registry delete localhost
}


### SCRIPT ###


ensure_cluster_exists \
    && delete_cluster \
    || printf 'cluster did not exist. skipping.\n'

ensure_registry_exists \
    && delete_registry \
    || printf 'registry did not exist. skipping.\n'
