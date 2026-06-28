{ ... }: {
  services.k3s.manifests.vane-svc.content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "vane-svc";
      namespace = "ai";
      annotations = {
        "metallb.io/address-pool" = "internal-pool";
      };
    };

    spec = {
      ports = [
        {
          port = 3000;
          targetPort = 3000;
          protocol = "TCP";
          name = "http";
        }
      ];

      selector = {
        app = "vane";
      };

      type = "LoadBalancer";
    };
  };
}
