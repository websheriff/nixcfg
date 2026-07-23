{ config, ... }: {
  sops.templates."grafana/grafana-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: grafana
        namespace: monitoring
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."grafana/domain"}`)
          kind: Rule
          services:
            - name: kube-prometheus-stack-grafana
              port: 3000
    '';

    path = "/var/lib/rancher/k3s/server/manifests/grafana-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
