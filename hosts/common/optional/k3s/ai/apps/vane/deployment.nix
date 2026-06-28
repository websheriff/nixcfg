{ config, ... }: {
  sops.templates."vane/vane-deploy.yaml" = {
    content = ''
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: vane
        namespace: ai
      labels:
        app: vane
      spec:
        replicas: 1
        strategy:
          type: Recreate
        selector:
          matchLabels:
            app: vane
        template:
          metadata:
            labels:
              app: vane
          spec:
            containers:
              - name: vane
                image: itzcrazykns1337/vane:v1.12.2
                imagePullPolicy: IfNotPresent
                ports:
                  - name: http
                    containerPort: 3000
                    protocol: TCP

                env:
                  - name: OPENAI_API_KEY
                    value: "not-needed"
                  - name: OPENAI_API_URL
                    value: "${config.sops.placeholder."kanto/ip"}:8080/v1"

                volumeMounts:
                  - name: vane-storage
                    mountPath: /home/vane/data

                resources:
                  requests:
                    cpu: 500m
                    memory: 512Mi
                  limits:
                    cpu: "1"
                    memory: 1Gi

            volumes:
              - name: vane-pvc
                persistentVolumeClaim:
                  claimName: vane-data-pvc
    '';

    path = "/var/lib/rancher/k3s/server/manifests/vane-deploy.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
