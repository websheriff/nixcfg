{ config, ... }: {
  sops.templates."ntfy/ntfy-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: ntfy
        namespace: monitoring
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."ntfy/domain"}`)
          kind: Rule
          services:
            - name: ntfy-svc
              port: 80
    '';

    path = "/var/lib/rancher/k3s/server/manifests/ntfy-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
