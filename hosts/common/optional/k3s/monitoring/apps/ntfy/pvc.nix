{ ... }: {
  services.k3s.manifests.ntfy-attachments-pvc.content = {
    apiVersion = "v1";
    kind = "PersistentVolumeClaim";
    metadata = {
      name = "ntfy-attachments-pvc";
      namespace = "monitoring";
    };

    spec = {
      accessModes = [ "ReadWriteOnce" ];
      storageClassName = "local-path";
      resources = {
        requests.storage = "2Gi";
      };
    };
  };
}
