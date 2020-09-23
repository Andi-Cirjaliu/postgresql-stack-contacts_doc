#!/bin/sh

export PGO_OPERATOR_NAMESPACE=pgo

kubectl create namespace pgo

cd /tmp && git clone -b sample-app https://github.com/operator-playground/postgres-operator && cd postgres-operator

kubectl create -f postgre.yaml
kubectl create -f secret.yaml

PGO_CMD=kubectl ./deploy/install-bootstrap-creds.sh && PGO_CMD=kubectl ./installers/kubectl/client-setup.sh

export PATH=/home/student/.pgo/pgo:$PATH
export PGOUSER=/home/student/.pgo/pgo/pgouser
export PGO_CA_CERT=/home/student/.pgo/pgo/client.crt
export PGO_CLIENT_CERT=/home/student/.pgo/pgo/client.crt
export PGO_CLIENT_KEY=/home/student/.pgo/pgo/client.key

curl -o service.yaml https://raw.githubusercontent.com/operator-playground/postgres-operator/sample-app/service.yaml && kubectl create -f service.yaml -n pgo
export PGO_APISERVER_URL=https://127.0.0.1:32443

pgo create cluster salesdb --username pguser --password password -n pgo
