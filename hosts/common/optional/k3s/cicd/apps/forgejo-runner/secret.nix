{ config, ... }: {
  sops.templates."forgejo/forgejo-runner-secret-init.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: forgejo-runner-secret-init
        namespace: cicd
      type: Opaque
      stringData:
        CONFIG_INSTANCE: "${config.sops.placeholder."forgejo/prod/domain"}"
        CONFIG_NAME: "Professor Oak"
        CONFIG_TOKEN: "${config.sops.placeholder."forgejo/runner/token"}"   
    '';

    path = "/var/lib/rancher/k3s/server/manifests/forgejo-runner-secret-init.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
