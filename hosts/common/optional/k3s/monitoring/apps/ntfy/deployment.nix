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
              app: ntfy
          spec:
            containers:
              - name: ntfy
                image: binwiederhier/ntfy:v2.25.0
                args: ["serve"]
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
                  - name: config
                    mountPath: /etc/ntfy
                    readOnly: true
                  - name: attachments
                    mountPath: /var/lib/ntfy/attachments
            volumes:
              - name: config
                configMap:
                  name: ntfy
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
