{ ... }: {

  sops.templates."jellyfin/jellyfin-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: pocketid
        namespace: kube-system
      spec:
        repo: https://jellyfin.github.io/jellyfin-helm/
        chart: jellyfin
        version: "3.2.0"
        targetNamespace: media
        createNamespace: false
        valuesContent: |
          replicaCount: 1

          image:
            pullPolicy: IfNotPresent

          persistence:
            config:
              enabled: true
              size: 2Gi
              storageClass: "local-path"

          resources:
            limits:
              cpu: 2000m
              memory: 4Gi
              gpu.intel.com/i915: 1
            requests:
              cpu: 500m
              memory: 1Gi

          service:
            type: LoadBalancer
            annotations:
              metallb.io/address-pool: internal-pool

          metrics:
            enabled: true
            serviceMonitor:
              enabled: true

          networkPolicy:
            enabled: true
            ingress:
              allowExternal: false
              namespaceSelector:
                matchLabels:
                  name: kube-system
              podSelector:
                matchLabels:
                  app.kubernetes.io/name: traefik
              
            egress:
              allowDNS: true
              allowAllEgress: false
              restrictedEgress:
                allowMetadata: true
                allowInCluster: false

            metrics:
              namespace: monitoring
              podSelector:
                app: prometheus
    '';

    path = "/var/lib/rancher/k3s/server/manifests/jellyfin-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
