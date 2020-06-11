#!/bin/bash -ex

SECRET=$1
TARGET_VOLUME=$2

SECRET_DATA=$(kubectl -n test get secret azure-service-principal -o json | jq .data)
APP_ID=$(echo $SECRET_DATA | jq -r .appId)
TENANT=$(echo $SECRET_DATA | jq -r .tenant)
PASSWORD=$(echo $SECRET_DATA | jq -r .password)

az login --service-principal -u ${APP_ID} -p ${PASSWORD} --tenant ${TENANT}
VOLUME_NAME=$(kubectl get pvc ${TARGET_VOLUME} -o json | jq -r '.spec.volumeName')
DISK_ID=$(az disk list --query "[].id | [?contains(@,\`${VOLUME_NAME}\`)]" -o tsv)
RESOURCE_GROUP=$(echo ${DISK_ID} | cut -d "/" -f 5)
az snapshot create \
  --resource-group ${RESOURCE_GROUP} \
  --name sftp_snapshot_$(date +%Y%m%d_%H_%M) \
  --source ${DISK_ID}
