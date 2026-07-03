{ config, ... }: {
  sops.templates."radarr/radarr-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: radarr
        namespace: media
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."arr/radarr/domain"}`)
          kind: Rule
          services:
          - name: radarr-svc
            port: 7878
    '';

    path = "/var/lib/rancher/k3s/server/manifests/radarr-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
