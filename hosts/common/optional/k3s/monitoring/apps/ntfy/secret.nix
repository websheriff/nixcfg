{ config, ... }: {
  sops.templates."ntfy/ntfy-database-auth.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: ntfy-db-auth
        namespace: monitoring
      type: Opaque
      stringData:
        username: "${config.sops.placeholder."ntfy/database/user"}"
        password: "${config.sops.placeholder."ntfy/database/password"}"
      type: kubernetes.io/basic-auth
    '';

    path = "/var/lib/rancher/k3s/server/manifests/ntfy-database-auth.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
