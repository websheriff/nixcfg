{ config, ... }: {
  sops.templates."prowlarr/prowlarr-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: prowlarr
        namespace: media
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."arr/prowlarr/domain"}`)
          kind: Rule
          services:
          - name: prowlarr-svc
            port: 9696
    '';

    path = "/var/lib/rancher/k3s/server/manifests/prowlarr-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
