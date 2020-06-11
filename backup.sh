#!/bin/bash -ex

TARGET_VOLUME=$1
VOLUME_NAME=$(kubectl get pvc ${TARGET_VOLUME} -o json | jq -r '.spec.volumeName')
DISK_ID=$(az disk list --query "[].id | [?contains(@,\`${VOLUME_NAME}\`)]" -o tsv)
RESOURCE_GROUP=$(echo ${DISK_ID} | cut -d "/" -f 5)
az snapshot create \
  --resource-group ${RESOURCE_GROUP} \
  --name sftp_snapshot_$(date +%Y%m%d_%H_%M) \
  --source ${DISK_ID}
