{ config, ... }: {

  sops.templates."vaultwarden/vaultwarden-database.yaml" = {
    content = ''
      apiVersion: postgresql.cnpg.io/v1
      kind: Cluster
      metadata:
        name: vaultwarden-db
        namespace: vaultwarden
      spec:
        instances: 1

        bootstrap:
          initdb:
            database: vaultwarden
            owner: ${config.sops.placeholder."vaultwarden/database/user"}
            secret:
              name: vaultwarden-db-auth

        storage:
          storageClass: local-path
          size: 1Gi
        walStorage:
          storageClass: local-path
          size: 1Gi
    '';

    path = "/var/lib/rancher/k3s/server/manifests/vaultwarden-database.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
