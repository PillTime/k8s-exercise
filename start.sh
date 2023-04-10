#!/bin/sh


### VARS ###


TRUE=0
FALSE=1
WAIT_SECS=120


### FUNCTIONS ###


ensure_registry_doesnt_exist() {
    k3d registry list --verbose | grep -i localhost > /dev/null 2>&1
    case $? in
        0)
            return "$FALSE"
            ;;
        *)
            return "$TRUE"
            ;;
    esac
}

ensure_cluster_doesnt_exist() {
    k3d cluster list --verbose | grep -i exercise > /dev/null 2>&1
    case $? in
        0)
            return "$FALSE"
            ;;
        *)
            return "$TRUE"
            ;;
    esac
}

# registry to store locally built docker image
# used by k8s to pull the image to the nodes that need it
create_registry() {
    k3d registry create localhost --port 5000
    return
}

# k8s cluster with 2 agents
# port 8080 exposed for access to the app's api
create_cluster() {
    k3d cluster create exercise --servers 1 --agents 2 \
        --registry-use k3d-localhost:5000 --port "8080:30080@server:0"
    return
}

# build and push docker image
prepare_image() {
    docker build . -t exercise-app \
    && docker tag exercise-app localhost:5000/exercise-app \
    && docker push localhost:5000/exercise-app
    return
}

deploy_db() {
    kubectl create -f postgres-secret.yml \
    && kubectl apply -f postgres-db-pv.yml \
    && kubectl apply -f postgres-db-pvc.yml \
    && kubectl apply -f postgres-db-deployment.yml \
    && kubectl apply -f postgres-db-service.yml
    return
}

# wait until the database starts running
wait_for_database() {
    SUCCESS=$FALSE
    while [ $WAIT_SECS != 0 ]; do
        sleep 1
        WAIT_SECS=$(($WAIT_SECS - 1))
        kubectl get pods | grep -i 'exercise-postgres' | grep -i 'running' \
            > /dev/null 2>&1
        if [ $? == 0 ]; then
            SUCCESS=$TRUE
            break
        fi
    done
    return $SUCCESS
}

deploy_app() {
    kubectl apply -f app-postgres-deployment.yml \
    && kubectl apply -f app-postgres-service.yml
    return
}


### SCRIPT ###


ensure_registry_doesnt_exist
if [ $? != 0 ]; then
    printf 'registry already exists. run ./stop.sh to remove it first.\n'
    exit 1
fi
ensure_cluster_doesnt_exist
if [ $? != 0 ]; then
    printf 'cluster already exists. run ./stop.sh to remove it first.\n'
    exit 1
fi

create_registry
if [ $? != 0 ]; then
    printf 'failed to create the registry.\n'
    exit 1
fi
create_cluster
if [ $? != 0 ]; then
    printf 'failed to create the cluster.\n'
    exit 1
fi
prepare_image
if [ $? != 0 ]; then
    printf 'failed to push the image to the local registry.\n'
    exit 1
fi

deploy_db
if [ $? != 0 ]; then
    printf 'failed to deploy the database.\n'
    exit 1
fi

printf 'waiting for postgres pod to start running...\n'
wait_for_database
if [ $? != 0 ]; then
    printf 'database pod still not running. check manually.\n'
    exit 1
fi

deploy_app
if [ $? != 0 ]; then
    printf 'failed to deploy the app.\n'
    exit 1
fi
