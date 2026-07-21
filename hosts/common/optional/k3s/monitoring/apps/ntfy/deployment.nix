{ config, ... }: {
  sops.templates."ntfy/ntfy-deployment.yaml" = {
    content = ''
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: ntfy
        namespace: monitoring
      spec:
        replicas: 1
        selector:
          matchLabels:
            app: ntfy
        template:
          metadata:
            labels:
              app:ntfy
          spec:
            containers:
              - name: ntfy
                image: binwiederhier/ntfy:v2.25.0
                args: ["serve"]
                env:
                  - name: NTFY_BASE_URL
                    value: "https://${config.sops.placeholder."ntfy/domain"}"
                  - name: NTFY_BEHIND_PROXY
                    value: "true"
                  - name: NTFY_DATABASE_URL
                    value: "${config.sops.placeholder."ntfy/database/url"}"
                  - name: NTFY_AUTH_DEFAULT_ACCESS
                    value: "deny-all"
                  - name: NTFY_ENABLE_LOGIN
                    value: "true"
                  - name: NTFY_REQUIRE_LOGIN
                    value: "true"
                  - name: NTFY_ATTACHMENT_CACHE_DIR
                    value: "/var/lib/ntfy/attachments"
                ports:
                  - containerPort: 80
                    name: http
                resources:
                  limits:
                    cpu: 500m
                    memory: 512Mi
                  requests:
                    cpu: 100m
                    memory: 128Mi
                volumeMounts:
                  - name: attachments
                    mountPath: /var/lib/ntfy/attachments
            volumes:
              - name: attachments
                persistentVolumeClaim:
                  claimName: ntfy-attachments-pvc
    '';

    path = "/var/lib/rancher/k3s/server/manifests/ntfy-deployment.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
