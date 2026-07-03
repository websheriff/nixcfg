{ config, ... }: {
  sops.templates."qbittorrent/qbittorrent-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: qbittorrent
        namespace: media
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."qbittorrent/domain"}`)
          kind: Rule
          services:
          - name: qbittorent-svc
            port: 3000
    '';

    path = "/var/lib/rancher/k3s/server/manifests/qbittorent-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
