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
              token: "${config.sops.placeholder."grafana/alert-manager/ntfy-token"}"
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
            GF_AUTH_GENERIC_OAUTH_CLIENT_ID: "${config.sops.placeholder."grafana/sso/client-id"}"
            GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET: "${config.sops.placeholder."grafana/sso/client-secret"}"
            GF_DATABASE_HOST: "${config.sops.placeholder."grafana/database/host"}"
            GF_DATABASE_USER: "${config.sops.placeholder."grafana/database/user"}"
            GF_DATABASE_PASSWORD: "${config.sops.placeholder."grafana/database/password"}"
            GF_RENDERING_RENDERER_TOKEN: "${config.sops.placeholder."grafana/renderer-token"}"
        '';

        path = "/var/lib/rancher/k3s/server/manifests/grafana-secret.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };
    };
  };
}
