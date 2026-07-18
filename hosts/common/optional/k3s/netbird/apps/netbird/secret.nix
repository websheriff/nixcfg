{ config, ... }: {

  sops = {
    secrets."netbird/domain" = {};
    secrets."netbird/setup-key" = {};
    secrets."netbird/access-token" = {};

    templates = {
      "netbird/secret.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: netbird-secret
            namespace: netbird
          type: Opaque
          stringData:
            setup-key: "${config.sops.placeholder."netbird/setup-key"}"
            access-token: "${config.sops.placeholder."netbird/access-token"}"
        '';

        path = "/var/lib/rancher/k3s/server/manifests/netbird-secret.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };
    };
  };
}
