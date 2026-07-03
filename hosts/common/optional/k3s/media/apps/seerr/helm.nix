{ ... }: {

  sops.templates."seerr/seerr-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: seerr
        namespace: kube-system
      spec:
        repo: oci://ghcr.io/seerr-team/seerr/seerr-chart
        chart: seerr
        version: "3.7.0"
        targetNamespace: media
        createNamespace: false
        valuesContent: |
          persistence:
            size: 2Gi
            storageClass: "local-path"

          resources:
            limits:
              cpu: 100m
              memory: 512Mi
            requests:
              cpu: 100m
              memory: 512Mi

          service:
            type: LoadBalancer
            annotations:
              metallb.io/address-pool: internal-pool
    '';

    path = "/var/lib/rancher/k3s/server/manifests/seerr-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
