{ ... }: {
  sops.templates."qbittorrent/qbittorrent-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: qbittorrent
        namespace: kube-system
      spec:
        repo: https://bjw-s-labs.github.io/helm-charts
        chart: app-template
        version: "4.6.2"
        targetNamespace: media
        createNamespace: false
        valuesContent: |
          defaultPodOptions:
            securityContext:
              fsGroup: 1000

          controllers:
            main:
              initContainers:
                copy-config:
                  image:
                    repository: alpine
                    tag: 3.19
                  command: ["sh", "-c", "cp -f /secret/* /config/ || true"]
              containers:
                gluetun:
                  image:
                    repository: ghcr.io/qmcgaw/gluetun
                    tag: v3.41.0
                  securityContext:
                    capabilities:
                      add: [ "NET_ADMIN" ]
                  env:
                    TZ: "America/Chicago"
                    # Allow direct (non-VPN) traffic to/from the cluster pod &
                    # service CIDRs so Traefik can reach the WebUI on 8080.
                    FIREWALL_OUTBOUND_SUBNETS: "10.42.0.0/16,10.43.0.0/16"
                    FIREWALL_INPUT_PORTS: "8080"
                    DOT: "off"
                    DNS_KEEP_NAMESERVER: "on"
                    HEALTH_VPN_DURATION_INITIAL: "120s"
                  envFrom:
                    - secretRef:
                        name: qbittorrent-vpn-secret

                qbittorrent:
                  image:
                    repository: ghcr.io/linuxserver/qbittorrent
                    tag: "5.2.1"
                  env:
                    TZ: "America/Chicago"
                    PUID: "1000"
                    PGID: "1000"
                    WEBUI_PORT: "8080"
                  resources:
                    requests:
                      memory: 2Gi
                    limits:
                      memory: 8Gi
                  probes:
                    liveness:
                      enabled: true
                      custom: true
                      spec:
                        httpGet:
                          path: /
                          port: 8080
                        initialDelaySeconds: 60
                        periodSeconds: 30
                        failureThreshold: 5
                    readiness:
                      enabled: true
                      custom: true
                      spec:
                        httpGet:
                          path: /
                          port: 8080
                        initialDelaySeconds: 30
                        periodSeconds: 15

          service:
            qbittorrent-svc:
              controller: main
              type: LoadBalancer
              annotations:
                metallb.io/address-pool: internal-pool
              ports:
                http:
                  port: 8080
                  protocol: TCP

          persistence:
            config:
              size: 2Gi
              accessMode: ReadWriteOnce
              advancedMounts:
                main:
                  qbittorrent:
                    - path: /config
                  copy-config:
                    - path: /config
            downloads:
              existingClaim: media-pvc
              advancedMounts:
                main:
                  qbittorrent:
                    - path: /media/Downloads
            qbittorrent-conf:
              type: secret
              name: qbittorrent-conf
              advancedMounts:
                main:
                  copy-config:
                    - path: /secret
                      readOnly: true
            tun:
              type: hostPath
              hostPath: /dev/net/tun
              hostPathType: CharDevice
              advancedMounts:
                main:
                  gluetun:
                    - path: /dev/net/tun
    '';
    path = "/var/lib/rancher/k3s/server/manifests/qbittorrent-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
