{ ... }: {
  services.k3s.manifests.vane-pvc.content = {
    apiVersion = "v1";
    kind = "PersistentVolumeClaim";
    metadata = {
      name = "vane-data-pvc";
      namespace = "ai";
      labels = {
        app = "vane";
      };
    };

    spec = {
      accessModes = [ "ReadWriteOnce" ];
      resources = {
        requests = {
          storage = "5Gi";
        };
      };
    };
  };
}
