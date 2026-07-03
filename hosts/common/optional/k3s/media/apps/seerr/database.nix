{ config, ... }: {
  sops.templates."seerr/seerr-database.yaml" = {
    content = ''
      apiVersion: postgresql.cnpg.io/v1
      kind: Cluster
      metadata:
        name: seerr-db
        namespace: media
      spec:
        instances: 1

        bootstrap:
          initdb:
            database: seerr
            owner: ${config.sops.placeholder."seerr/database/user"}
            secret:
              name: seerr-db-auth

        managed:
          services:
            disabledDefaultServices: [ "ro", "r" ]

        storage:
          storageClass: local-path
          size: 1Gi
        walStorage:
          storageClass: local-path
          size: 1Gi
    '';

    path = "/var/lib/rancher/k3s/server/manifests/seerr-database.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
