{ config, ... }: {

  sops.templates."vane/vane-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: vane
        namespace: ai
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."vane/domain"}`)
          kind: Rule
          services:
          - name: vane-svc
            port: 3000
    '';

    path = "/var/lib/rancher/k3s/server/manifests/vane-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
