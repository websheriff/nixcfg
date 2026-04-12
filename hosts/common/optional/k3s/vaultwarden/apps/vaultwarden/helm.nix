{ config, ... }: {

  sops.templates."vaultwarden/vaultwarden-helm" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: vaultwarden
        namespace: kube-system
      spec:
        repo: https://guerzon.github.io/vaultwarden
        chart: vaultwarden
        version: "0.35.1"
        targetNamespace: vaultwarden
        createNamespace: true
        vaulesContent: |

          domain: "https://${config.sops.placeholder."vaultwarden/domain"}/"

          adminToken:
            existingSecret: vaultwarden-admin
            existingSecretKey: admin-token

          timeZone: "America/Chicago"

          ingress:
            enabled: true
            class: "traefik"
            hostname: ${config.sops.placeholder."vaultwarden/domain"}
            nginxIngressAnnotations: false
            path: "/"
            pathType: Prefix

          service:
            annotations:
              metallb.io/address-pool: internal-pool

          database:
            type: postgresql
            existingSecret: vaultwarden-db
            existingSecretKey: uri

          storage:
            data:
              name: "vaultwarden-data"
              size: "5Gi"
              class: "local-path"
              keepPvc: true
            attachments:
              name: "vaultwarden-files"
              size: "5Gi"
              class: "local-path"
              keepPvc: true
            
          sso:
            enabled: true
            authority: ${config.sops.placeholder."vaultwarden/sso/auth-url"}
            existingSecret: vaultwarden-oidc
            clientId:
              existingSecretKey: client-id
            clientSecret:
              existingSecretKey: client-secret
            enforceSSO: true
    '';

    path = "/var/lib/rancher/k3s/server/manifests/vaultwarden-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
