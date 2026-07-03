{ ... }: {

  sops.templates."seerr/seerr-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: seerr
        namespace: kube-system
      spec:
        repo: oci://ghcr.io/seerr-team/seerr/seerr-chart
        chart: seerr
        version: "3.7.0"
        targetNamespace: media
        createNamespace: false
        valuesContent: |
          extraEnv:
            - name: TZ
              value: America/Chicago
            - name: DB_TYPE
              value: postgres
            - name: DB_NAME
              value: seerr
            - name: DB_HOST
              valueFrom:
                secretKeyRef:
                  key: host
                  name: seerr-db
            - name: DB_USER
              valueFrom:
                secretKeyRef:
                  key: username
                  name: seerr-db
            - name: DB_PASS
              valueFrom:
                secretKeyRef:
                  key: password
                  name: seerr-db
                  
          persistence:
            size: 1Gi
            storageClass: "local-path"

          resources:
            limits:
              cpu: 100m
              memory: 512Mi
            requests:
              cpu: 100m
              memory: 512Mi

          service:
            type: LoadBalancer
            annotations:
              metallb.io/address-pool: internal-pool
    '';

    path = "/var/lib/rancher/k3s/server/manifests/seerr-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
