{ config, ... }: {

sops.templates."fluxcd/fluxinstance.yaml" = {
  content = ''
    apiVersion: fluxcd.controlplane.io/v1
    kind: FluxInstance
    metadata:
      name: flux
      namespace: flux-system
    spec:
      distribution:
        version: "2.x"
        registry: "ghcr.io/fluxcd"
      components:
        - source-controller
        - kustomize-controller
        - helm-controller
        - notification-controller
        - image-reflector-controller
        - image-automation-controller
      sync:
        kind: GitRepository
        url: ssh://forgejo@${config.sops.placeholder."forgejo/dev/domain"}/websheriff/nixcfg.git
        ref: master
        path: ../../../../k3s
        interval: 2m
        pullSecret: "forgejo-auth"
    '';
    path = "/var/lib/rancher/k3s/server/manifests/fluxinstance.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
