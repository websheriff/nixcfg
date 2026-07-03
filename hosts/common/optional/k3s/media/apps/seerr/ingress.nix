{ config, ... }: {

  sops.templates."seerr/seerr-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: seerr
        namespace: media
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."seerr/domain"}`)
          kind: Rule
          services:
          - name: seerr
            port: 80
    '';

    path = "/var/lib/rancher/k3s/server/manifests/seerr-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
