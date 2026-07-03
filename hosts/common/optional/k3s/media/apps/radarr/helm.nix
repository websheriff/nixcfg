{ ... }: {
  sops.templates."radarr/radarr-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: radarr
        namespace: kube-system
      spec:
        repo: https://bjw-s-labs.github.io/helm-charts
        chart: app-template
        version: "4.6.2"
        targetNamespace: media
        createNamespace: false
        valuesContent: |
          controllers:
            radarr:
              containers:
                main:
                  image:
                    repository: ghcr.io/linuxserver/radarr
                    tag: 6.1.1
                    pullPolicy: IfNotPresent
                  env:
                    TZ: "America/Chicago"
                    PUID: "1000"
                    PGID: "1000"
          service:
            radarr-svc:
              controller: radarr
              type: LoadBalancer
              annotations:
                metallb.io/address-pool: internal-pool
              ports:
                http:
                  port: 7878
                  protocol: TCP
          persistence:
            downloads:
              existingClaim: media-pvc
              globalMounts:
                - path: /media/Downloads
            config:
              size: 2Gi
              accessMode: ReadWriteOnce
    '';

    path = "/var/lib/rancher/k3s/server/manifests/radarr-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
