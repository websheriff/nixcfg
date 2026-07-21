{ config, ... }: {
  sops.templates."ntfy/ntfy-configmap.yaml" = {
    content = ''
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: ntfy
        namespace: monitoring
      data:
        server.yml: |
          base-url: https://${config.sops.placeholder."ntfy/domain"}
          database-url: "postgres://${config.sops.placeholder."ntfy/database/user"}:${
            config.sops.placeholder."ntfy/database/password"
          }@${config.sops.placeholder."ntfy/database/host"}:5432/ntfy"
          behind-proxy: true
          enable-signup: false
          enable-login: true
          require-login: true
          attachment-cache-dir: /var/lib/ntfy/attachments
          attachment-total-size-limit: "5G"
          attachment-file-size-limit: "15M"
          attachment-expiry-duration: "24h"
    '';

    path = "/var/lib/rancher/k3s/server/manifests/ntfy-configmap.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
