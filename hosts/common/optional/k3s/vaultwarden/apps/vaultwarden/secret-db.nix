{ config, ... }: {

  sops.templates."vaultwarden/secret-db.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: vaultwarden-db
        namespace: vaultwarden
      type: Opaque
      stringData:
        uri: "postgresql://${config.sops.placeholder."vaultwarden/database/user"}:${config.sops.placeholder."vaultwarden/database/password"}@${config.sops.placeholder."vaultwarden/database/host"}:5432/vaultwarden"
    '';

    path = "/var/lib/rancher/k3s/server/manifests/vaultwarden-secret-db.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
