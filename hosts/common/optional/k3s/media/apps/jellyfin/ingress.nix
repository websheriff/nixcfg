{ config, ... }: {

  sops.templates."jellyfin/jellyfin-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: jellyfin
        namespace: media
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."jellyfin/domain"}`)
          kind: Rule
          services:
          - name: jellyfin
            port: 80
    '';

    path = "/var/lib/rancher/k3s/server/manifests/jellyfin-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
