{ config, ... }: {
  sops = {
    templates = {
      "alertmanager-nfty/alertmanager-nfty-auth.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: alertmanager-nfty-auth
            namespace: monitoring
          type: Opaque
          stringData:
            auth.yml: |
              baseurl: "${config.sops.placeholder."ntfy/domain"}"
              token: "${config.sops.placeholder."ntfy/alertmanager-token"}"
        '';

        path = "/var/lib/rancher/k3s/server/manifests/alertmanager-ntfy-auth.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };

      "grafana/grafana-database-auth.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: grafana-db-auth
            namespace: monitoring
          type: Opaque
          stringData:
            username: "${config.sops.placeholder."grafana/database/user"}"
            password: "${config.sops.placeholder."grafana/database/password"}"
          type: kubernetes.io/basic-auth
        '';

        path = "/var/lib/rancher/k3s/server/manifests/grafana-database-auth.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };

      "grafana/grafana-secret.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: grafana-secret
            namespace: monitoring
          type: Opaque
          stringData:
            GF_CLIENT_ID: "${config.sops.placeholder."grafana/sso/client-id"}"
            GF_CLIENT_SECRET: "${config.sops.placeholder."grafana/sso/client-secret"}"
            GF_DB_HOST: "${config.sops.placeholder."grafana/database/host"}"
            GF_DB_USER: "${config.sops.placeholder."grafana/database/user"}"
            GF_DB_PASSWORD: "${config.sops.placeholder."grafana/database/password"}"
        '';

        path = "/var/lib/rancher/k3s/server/manifests/grafana-secret.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };
    };
  };
}
