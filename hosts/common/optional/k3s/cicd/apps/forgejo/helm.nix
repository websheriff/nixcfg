{ config, ... }: {

  sops.templates."forgejo/forgejo-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: forgejo
        namespace: kube-system
      spec:
        chart: oci://code.forgejo.org/forgejo-helm/forgejo
        version: "17.1.1"
        targetNamespace: cicd
        createNamespace: false
        valuesContent: |
          gitea:
            metrics:
              enabled: true
              serviceMonitor:
                enabled: false

            admin:
              existingSecret: forgejo-admin

            oauth:
              - name: 'Pocket ID'
                provider: 'openidConnect'
                autoDiscoverUrl: 'https://${
                  config.sops.placeholder."pocketid/domain"
                }/.well-known/openid-configuration'
                existingSecret: forgejo-oauth

            config:
              server:
                ROOT_URL: https://${config.sops.placeholder."forgejo/prod/domain"}
                SSH_DOMAIN: ${config.sops.placeholder."forgejo/prod/domain"}

              database:
                DB_TYPE: postgres
                NAME: forgejo

              migrations:
                ALLOWED_DOMAINS: "${config.sops.placeholder."forgejo/dev/domain"}"
                ALLOW_LOCALNETWORKS: true

            additionalConfigFromEnvs:
              - name: FORGEJO__DATABASE__HOST
                valueFrom:
                  secretKeyRef:
                    name: forgejo-db
                    key: host
              - name: FORGEJO__DATABASE__USER
                valueFrom:
                  secretKeyRef:
                    name: forgejo-db
                    key: user
              - name: FORGEJO__DATABASE__PASSWD
                valueFrom:
                  secretKeyRef:
                    name: forgejo-db
                    key: password
                    
          service:
            http:
              type: LoadBalancer
              annotations:
                metallb.io/address-pool: internal-pool
                metallb.io/allow-shared-ip: "forgejo"
            ssh:
              type: LoadBalancer
              annotations:
                metallb.io/address-pool: internal-pool
                metallb.io/allow-shared-ip: "forgejo"

          ingress:
            enabled: false
    '';

    path = "/var/lib/rancher/k3s/server/manifests/forgejo-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
