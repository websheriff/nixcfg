{ config, ... }: {

  sops.templates."vaultwarden/secret-admin.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: vaultwarden-admin
        namespace: vaultwarden
      type: Opaque
      stringData:
        admin-token: "${config.sops.placeholder."vaultwarden/admin-token"}"
    '';

    path = "/var/lib/rancher/k3s/server/manifests/vaultwarden-secret-admin.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
