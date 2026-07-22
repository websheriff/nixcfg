{ config, ... }: {

  sops.templates."grafana/grafana-database.yaml" = {
    content = ''
      apiVersion: postgresql.cnpg.io/v1
      kind: Cluster
      metadata:
        name: grafana-db
        namespace: monitoring
      spec:
        instances: 1

        bootstrap:
          initdb:
            database: grafana
            owner: ${config.sops.placeholder."grafana/database/user"}
            secret:
              name: grafana-db-auth

        managed:
          services:
            disabledDefaultServices: [ "ro", "r" ]

        storage:
          storageClass: local-path
          size: 5Gi
        walStorage:
          storageClass: local-path
          size: 5Gi
    '';

    path = "/var/lib/rancher/k3s/server/manifests/grafana-database.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
