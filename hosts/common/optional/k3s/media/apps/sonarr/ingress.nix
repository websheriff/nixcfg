{ config, ... }: {
  sops.templates."sonarr/sonarr-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: sonarr
        namespace: media
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."arr/sonarr/domain"}`)
          kind: Rule
          services:
          - name: sonarr-svc
            port: 8989
    '';

    path = "/var/lib/rancher/k3s/server/manifests/sonarr-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
