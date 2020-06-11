# azure-disk-k8s-pvc-backup
A Docker image designed to back up an Azure Disk Persistant Volume Claim. Intended to be run from a K8s cronjob

## Usage
Helm:
```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: {{ include "chart.fullname" . }}-backup
spec:
  schedule: "0 0 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: millergeek/azure-disk-k8s-pvc-backup
            args:
            # Name of the PVC you want to back up
            - {{ include "chart.fullname" . }}-volume-claim
          restartPolicy: OnFailure
```
