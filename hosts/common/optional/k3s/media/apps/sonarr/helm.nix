{ ... }: {
  sops.templates."sonarr/sonarr-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: sonarr
        namespace: kube-system
      spec:
        repo: https://bjw-s-labs.github.io/helm-charts
        chart: app-template
        version: "4.6.2"
        targetNamespace: media
        createNamespace: false
        valuesContent: |
          controllers:
            sonarr:
              containers:
                main:
                  image:
                    repository: ghcr.io/linuxserver/sonarr
                    tag: 4.0.17
                    pullPolicy: IfNotPresent
                  env:
                    TZ: "America/Chicago"
                    PUID: "1000"
                    PGID: "1000"
          service:
            sonarr-svc:
              controller: sonarr
              type: LoadBalancer
              annotations:
                metallb.io/address-pool: internal-pool
              ports:
                http:
                  port: 8989
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

    path = "/var/lib/rancher/k3s/server/manifests/sonarr-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
