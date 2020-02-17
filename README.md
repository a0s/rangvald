# Rangvald

> Dockerize and deploy sample Django app to Minikube.

Options:
 - raw yaml files for kubectl
 - Terraform-based deployment
 - Helm3-based deployment

```shell script
> git clone https://github.com/a0s/rangvald
> cd rangvald
``` 

Naming:

    API - Sample Django app from https://github.com/shacker/gtd.git
    DB - Postgres 12.1

# Build image

Alpine-based image

```shell script
> ./api-image/build.sh

REPOSITORY                       TAG                 IMAGE ID            CREATED             SIZE
django-todo                      latest              4ba28edef3c4        3 minutes ago       222MB
```

## Test image with docker-compose

```shell script
> ./docker-compose/run.sh
```

http://localhost:8000

# Deploy to minikube

Don't forget to switch context to your local Docker on Mac

```shell script
> kubectl config get-contexts
CURRENT   NAME                 CLUSTER          AUTHINFO                NAMESPACE
*         docker-desktop       docker-desktop   docker-desktop
          docker-for-desktop   docker-desktop   docker-desktop
```

## Kubectl

```shell script
> kubectl apply -f ./minikube-kubectl
```
Then wait for some time and check http://localhost:8080

It will deploy 1 pod for DB and 3 pods for API in namespace `rangvald`. 
Most of the variables were hardcoded. 
Db settings are passing through ConfigMap (it should be Secret on production).  

## Terraform

This is almost the same as kubectl, ConfigMap was skipped, many variables were added.

Prerequisites:

```shell script
> terraform -v
Terraform v0.12.20
```

Deploying:

```shell script
> cd minikube-terraform
> terraform init
> terraform apply
```

Wait for some time and check http://localhost:8080

```shell script
> kubectl get all,configmaps -n rangvald

NAME                      READY   STATUS    RESTARTS   AGE
pod/api-8fb6748cd-d84fc   1/1     Running   0          52s
pod/api-8fb6748cd-ftslb   1/1     Running   0          52s
pod/api-8fb6748cd-p9g9b   1/1     Running   0          52s
pod/db-5b7c649564-dhshd   1/1     Running   0          51s


NAME          TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
service/api   LoadBalancer   10.98.173.84   localhost     8080:31946/TCP   53s
service/db    ClusterIP      10.96.220.54   <none>        5432/TCP         53s


NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/api   3/3     3            3           52s
deployment.apps/db    1/1     1            1           51s

NAME                            DESIRED   CURRENT   READY   AGE
replicaset.apps/api-8fb6748cd   3         3         3       52s
replicaset.apps/db-5b7c649564   1         1         1       51s
```

There are many variables that can be changed with Terraform's `TF_VAR_` variable settings:

| Variable name             | Default value                           | Description                                              |
|---------------------------|-----------------------------------------|----------------------------------------------------------|
| kube_host                 | https://kubernetes.docker.internal:6443 |                                                          |
| kube_config_path          | ~/.kube/config                          |                                                          |
| kube_config_context       | docker-desktop                          |                                                          |
| namespace                 | rangvald                                |                                                          |
| db_name                   | somedb                                  |                                                          |
| db_user                   | someusername                            |                                                          |
| db_password               | somepassword                            | Password for DB!                                         |
| db_volume_size            | 5G                                      | Capacity for PersistentVolume and  PersistentVolumeClaim |
| db_image                  | postgres:12.1-alpine                    |                                                          |
| db_initial_delay_seconds  | 10                                      | readinessProbe.initialDelaySeconds for DB                |
| db_failure_threshold      | 1                                       | readinessProbe.failureThreshold for DB                   |
| db_period_seconds         | 5                                       | readinessProbe.periodSeconds for DB                      |
| api_pods_count            | 3                                       | Number of api's replicas                                 |
| api_image                 | django-todo:latest                      |                                                          |
| api_initial_delay_seconds | 5                                       | readinessProbe.initialDelaySeconds for API               |
| api_failure_threshold     | 1                                       | readinessProbe.failureThreshold for API                  |
| api_period_seconds        | 5                                       | readinessProbe.periodSeconds for API                     |
| api_external_port         | 8080                                    | Localhost's port to open site                            |

## Helm

Prerequisites:

```shell script
> helm version                                                                                         ruby-2.6.3
version.BuildInfo{Version:"v3.0.3", GitCommit:"ac925eb7279f4a6955df663a0128044a8a6b7593", GitTreeState:"clean", GoVersion:"go1.13.7"}
```

Deploying without secrets:

```
> helm install rangvald minikube-helm --set db.config.dbPassword=not_secret_password
```

Deploying with secrets:

```
# Create secret in kube
> kubectl create secret generic db-config \
    --from-literal=db_name=secret_db \
    --from-literal=db_user=secret_user \
    --from-literal=db_password=1111

# Use secret during deploy
> helm install rangvald minikube-helm --set db.config.type=secret
```

There are many config options prepared for this helm chart in [values.yaml](minikube-helm/values.yaml)
