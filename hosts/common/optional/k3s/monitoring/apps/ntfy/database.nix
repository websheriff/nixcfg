{ config, ... }: {
  sops.templates."ntfy/ntfy-database.yaml" = {
    content = ''
      apiVersion: postgresql.cnpg.io/v1
      kind: Cluster
      metadata:
        name: ntfy-db
        namespace: monitoring
      spec:
        instances: 1

        bootstrap:
          initdb:
            database: ntfy
            owner: ${config.sops.placeholder."ntfy/database/user"}
            secret:
              name: ntfy-db-auth

        managed:
          services:
            disabledDefaultServices: [ "ro", "r" ]

        storage:
          storageClass: local-path
          size: 2Gi
        walStorage:
          storageClass: local-path
          size: 2Gi
    '';

    path = "/var/lib/rancher/k3s/server/manifests/ntfy-database.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
