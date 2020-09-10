# Jenkins on Kubernetes ##

Topics:

- A Kubernetes cluster with Minikube
- Install and configure Jenkins from Helm
- Build, deploy and run container from Jenkinsfile

## Instructions Overview ##

- Start a Kubernetes cluster
- Install Jenkins on the cluster
- Create a pipeline that builds on and publishes to Kubernetes

------------

## Setup ##

### Install ##

1. Install [Minikube v1.13.0](https://kubernetes.io/docs/tasks/tools/install-minikube/) runs a single-node Kubernetes cluster
1. Install [kubectl v1.16.6](https://kubernetes.io/docs/tasks/tools/install-kubectl//) command line tool for Kubernetes
1. Install [Helm v3.3.1](https://docs.helm.sh/using_helm/), a package manager for Kubernetes based applications

### Start ###

1. Start Minikube with Helm: From project root run `./start.sh`. This will provision a personal Kubernetes cluster.
1. Verify `minikube status` and `kubectl version` and `helm version` run correctly

------------

## Jenkins ##

### Install Jenkins on Kubernetes ###

create jenkins namespace

`kubectl create -f jenkins-namespace.yml`

create jenkins volume

`kubectl create -f jenkins-volume.yml`

To start Jenkins use Helm to install the stable/Jenkins chart.

``` sh
helm install jenkins stable/jenkins --namespace jenkins -f ./jenkins-values.yaml
```

The jenkins-values.yaml file includes details for the Jenkins configuration to ensure it starts with all the appropriate plugins, along with its Kubernetes plugin. The Jenkins chart also installs a definition for a custom container for running Jenkins jobs.


Verify Jenkins is starting with this Kubernetes introspection command:

``` sh
kubectl get deployments,pods -n jenkins
```

Run this command until the deployment changes the *Available* status from 0 to 1. This will take a few minutes.

There will now be a Jenkins service available that you can access through a Kubernetes NodePort. List the available services with this:

``` sh
minikube service list
```

Look for the Jenkins service in the namespace `jenkins` and ask Minikube to point your default browser to the Jenkins UI with this:

``` sh
minikube service -n jenkins jenkins
```

Look for POD_NAME to forward port to browser to the Jenkins UI with http://localhost:8000

``` sh
 export POD_NAME=$(kubectl get pods --namespace jenkins -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=jenkins" -o jsonpath="{.items[0].metadata.name}")\n

 kubectl --namespace jenkins port-forward $POD_NAME 8080:8080
```

In the jenkins-values.yaml file is a list of defined plugins. Through the Jenkins dashboard observe those plugins are present.

### Create a Jenkins Pipeline ###

Navigate to the main Jenkins page:

From Jenkins main page, create a new Job:

1. Select "New Item"
1. Execute the shell
1. shell: `git clone https://github.com/m94221006/BigGoTesting.git`  
1. Select Save

### Initial Run ###

1. Click 'Build Now'
1. View build console output and notice the job is waiting for container agent
1. Agent appears in Jenkins main
1. Go to the Minikube dashboard and observe the Jenkins agent container spinning up

### Presentation Short Instructions ###

| Step                       | Command
|----------------------------|---------
| Fresh Minikube             | `minikube delete`
| Initialize                 | `./start.sh`
| Deploy Jenkins             | `helm install stable/jenkins --namespace jenkins --name jenkins -f ./jenkins-values.yaml`

