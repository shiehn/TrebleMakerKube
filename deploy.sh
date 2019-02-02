#!/bin/bash

#check for minikube and kubectl
command -v minikube >/dev/null 2>&1 || { echo >&2 "Please install MiniKube!  Aborting."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo >&2 "Please install KubeCtl!  Aborting."; exit 1; }

#start up kubernettes
minikube start --vm-driver kvm2 --memory 20000 --cpus 10

#delete previous deployments etc
kubectl delete daemonsets,replicasets,services,deployments,pods,rc --all

#create persistant disk
kubectl create -f mysql-volume.yaml

#deploy mysql
kubectl create -f mysql-deployment.yaml

#download data dump
rm -rf treblemaker-db.sql
curl -o treblemaker-db.sql https://s3-us-west-2.amazonaws.com/treblemakerdeps/treblemaker-db.sql
chmod +x treblemaker-db.sql

#restore db from data dump

POD=""
while [ -z "$POD" ]
do
  POD="$(kubectl get pod -l app=mysql -o jsonpath="{.items[0].metadata.name}")"
  echo "waiting for pod name from mysql = ${POD}"
  sleep 5
done

STATUS=""
while [ ! "${STATUS}" = "running" ]
do
  STATUS="$(kubectl get pod -l app=mysql -o jsonpath="{.items[0].status.phase}")"
  typeset -l STATUS
  echo "waiting for pod name mysql status to be running = ${STATUS}"
  sleep 5
done

kubectl exec -i ${POD} -- mysql -u root -pmaker hivecomposedb < treblemaker-db.sql

#deploy treblemakerapi
kubectl create -f treblemakerapi-deployment.yaml

STATUS=""
while [ ! "${STATUS}" = "running" ]
do
  STATUS="$(kubectl get pod -l app=treblemakerapi -o jsonpath="{.items[0].status.phase}")"
  typeset -l STATUS
  echo "waiting for pod name treblemakerapi status to be running = ${STATUS}"
  sleep 5
done

#deploy hazelcast
kubectl create -f hazelcast-deployment.yaml

STATUS=""
while [ ! "${STATUS}" = "running" ]
do
  STATUS="$(kubectl get pod -l app=hazelcast -o jsonpath="{.items[0].status.phase}")"
  typeset -l STATUS
  echo "waiting for pod name hazelcast status to be running = ${STATUS}"
  sleep 5
done

#deploy treblemakercore
kubectl create -f treblemakercore-deployment.yaml

#deploy treblemakerweb
#kubectl create -f treblemakerweb-deployment.yaml

echo 'TrebleMaker is deployed to MiniKube'


