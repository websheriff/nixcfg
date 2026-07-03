{ ... }: {
  sops.templates."prowlarr/prowlarr-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: prowlarr
        namespace: kube-system
      spec:
        repo: https://bjw-s-labs.github.io/helm-charts
        chart: app-template
        version: "4.6.2"
        targetNamespace: media
        createNamespace: false
        valuesContent: |
          controllers:
            prowlarr:
              containers:
                main:
                  image:
                    repository: ghcr.io/linuxserver/prowlarr
                    tag: 2.4.0
                    pullPolicy: IfNotPresent
                  env:
                    TZ: "America/Chicago"
                    PUID: "1000"
                    PGID: "1000"
          service:
            prowlarr-svc:
              controller: prowlarr
              type: LoadBalancer
              annotations:
                metallb.io/address-pool: internal-pool
              ports:
                http:
                  port: 9696
                  protocol: TCP
          persistence:
            config:
              size: 2Gi
              accessMode: ReadWriteOnce
    '';

    path = "/var/lib/rancher/k3s/server/manifests/prowlarr-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
