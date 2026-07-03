{ config, ... }: {
  sops.templates."seerr/seerr-database-auth.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: seerr-db-auth
        namespace: media
      stringData:
        host: "${config.sops.placeholder."seerr/database/host"}"
        username: "${config.sops.placeholder."seerr/database/user"}"
        password: "${config.sops.placeholder."seerr/database/password"}"
      type: kubernetes.io/basic-auth
    '';

    path = "/var/lib/rancher/k3s/server/manifests/seerr-database-auth.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
