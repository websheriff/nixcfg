{ config, ... }: {

  sops.templates = {
    "fluxcd/fluxcd-git-auth.yaml" = {
      content = ''
        apiVersion: v1
        kind: Secret
        metadata:
          name: forgejo-auth
          namespace: flux-system
          labels:
            toolkit.fluxcd.io/secret-type: git
        type: Opaque
        stringData:
          identity: |2
            ${config.sops.placeholder."fluxcd/ssh-key"}
          known_hosts: |
            ${config.sops.placeholder."forgejo/dev/known-host"}
      '';
      path = "/var/lib/rancher/k3s/server/manifests/fluxcd-git-auth.yaml";
      owner = "root";
      group = "root";
      mode = "0644";
    };
  };
}
