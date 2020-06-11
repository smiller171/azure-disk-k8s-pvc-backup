FROM millergeek/kubectl as kubectl

FROM mcr.microsoft.com/azure-cli
COPY --from=kubectl /kubectl /usr/local/bin/kubectl
COPY backup.sh /usr/local/bin/pvc-backup
ENTRYPOINT [ "/usr/local/bin/pvc-backup" ]
