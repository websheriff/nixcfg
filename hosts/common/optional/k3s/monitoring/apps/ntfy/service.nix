{ ... }: {
  services.k3s.manifests.ntfy-svc.content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "ntfy-svc";
      namespace = "monitoring";
      annotations = {
        "metallb.io/address-pool" = "internal-pool";
      };
      labels = {
        "app.kubernetes.io/name" = "ntfy";
        "app.kubernetes.io/instance" = "ntfy";
      };
    };

    spec = {
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 80;
          targetPort = 80;
        }
      ];

      selector = {
        app = "ntfy";
      };

      type = "LoadBalancer";
    };
  };
}
