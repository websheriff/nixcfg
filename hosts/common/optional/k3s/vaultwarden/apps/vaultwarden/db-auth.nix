{ config, ... }: {

  sops.templates."vaultwarden/database-auth.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: vaultwarden-db-auth
        namespace: vaultwarden
      stringData:
        username: "${config.sops.placeholder."vaultwarden/database/user"}"
        password: "${config.sops.placeholder."vaultwarden/database/password"}"
    '';

    path = "/var/lib/rancher/k3s/server/manifests/vaultwarden-database-auth.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
