{ config, ... }: {
  sops.templates."kube-prometheus-stack/kube-prometheus-stack-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: kube-prometheus-stack
        namespace: kube-system
      spec:
        repo: https://prometheus-community.github.io/helm-charts
        chart: kube-prometheus-stack
        version: "87.18.1"
        targetNamespace: monitoring
        createNamespace: false
        valuesContent: |
          #K3s included
          kubeControllerManager:
            enabled: false
          kubeScheduler:
            enabled: false
          kubeProxy:
            enabled: false

          defaultRules:
            disabled:
              Watchdog: true
              InfoInhibitor: true
            
          prometheusOperator:
            admissionWebhooks:
              enabled: false
            tls:
              enabled: false

          alertmanager:
            service:
              type: ClusterIP
            alertmanagerSpec:
              image:
                tag: v0.33.0

              containers:
                - name: alertmanager-ntfy
                  image: ghcr.io/alexbakker/alertmanager-ntfy:1.2.1
                  args:
                    - "--configs=/etc/alertmanager-ntfy/config.yml,/etc/alertmanager-nfty-auth/auth.yml"
                  volumeMounts:
                    - name: config
                      mountPath: /etc/alertmanager-ntfy
                    - name: auth
                      mountPath: /etc/alertmanager-ntfy-auth
                  ports:
                    - name: ntfy-alertmanager-bridge
                      containerPort: 5000
                      protocol: TCP
                  resources:
                    limits:
                      cpu: 100m
                      memory: 128Mi
                    requests:
                      cpu: 10m
                      memory: 32Mi
              volumes:
                - name: config-volume
                  configMap:
                    name: alertmanager-ntfy-config
                - name: alertmanager-ntfy-auth
                  secret:
                    secretName: alertmanager-ntfy-auth
            
            config:
              route:
                group_by: ["alertname", "namespace"]
                group_wait: 10s
                group_interval: 5m
                repeat_interval: 24h
                receiver: ntfy
              receivers:
                - name: "ntfy"
                  webhook_configs:
                    - url: http://127.0.0.1:5000/alertmanager

          prometheus:
            service:
              type: ClusterIP

            prometheusSpec:
              image:
                tag: v3.12.0
              enableFeatures:
                - otlp-write-receiver
              enableRemoteWriteReceiver: true
              # Discover monitors from any namespace/release, not just this chart's.
              serviceMonitorSelectorNilUsesHelmValues: false
              podMonitorSelectorNilUsesHelmValues: false
              ruleSelectorNilUsesHelmValues: false
              probeSelectorNilUsesHelmValues: false
              scrapeConfigSelectorNilUsesHelmValues: false

          kube-state-metrics:
            image:
              tag: v2.19.1

          prometheus-node-exporter:
            image:
              distroless: false

          grafana:
            sidecar:
              image:
                tag: 2.8.0
            service:
              type: LoadBalancer
              port: 3000
              annotations:
                metallb.io/address-pool: internal-pool
              dashboards:
                enabled: true
                label: grafana-dashboard
                labelValue: "1"
                searchNamespace: monitoring
            env:
              GF_RENDERING_SERVER_URL: "http://grafana-image-renderer.monitoring.svc.cluster.local:8081/render"
              GF_RENDERING_CALLBACK_URL: "http://kube-prometheus-stack-grafana.monitoring.svc.cluster.local:32000/"

            envFromSecret: grafana-secret
            assertNoLeakedSecrets: false
                             
            grafana.ini:
              server:
                root_url: "https://${config.sops.placeholder."grafana/domain"}"
                serve_from_sub_path: false
                domain: "${config.sops.placeholder."grafana/domain"}"
              auth.generic_oauth:
                enabled: true
                validate_id_token: true
                name: "SSO"
                allow_sign_up: true
                allow_assign_grafana_admin: true
                scopes: "openid profile email groups"
                auth_url: "https://${config.sops.placeholder."pocketid/domain"}/authorize"
                token_url: "https://${config.sops.placeholder."pocketid/domain"}/api/oidc/token"
                api_url: "https://${config.sops.placeholder."pocketid/domain"}/api/oidc/userinfo"
                jwk_set_url: "https://${config.sops.placeholder."pocketid/domain"}/.well-known/jwks.json"
              database:
                type: postgres

    '';

    path = "/var/lib/rancher/k3s/server/manifests/kube-prometheus-stack-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
