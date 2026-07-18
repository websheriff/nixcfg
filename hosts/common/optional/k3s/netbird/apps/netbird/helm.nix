{ ... }: {
  services.k3s.autoDeployCharts = {
    name = "netbird-operator";
    repo = "oci://ghcr.io/netbirdio/helm-charts/netbird-operator";
    hash = "";
    targetNamespace = "netbird";
    createNamespace = false;
    version = "v0.3.1";
    values = {
      netbirdAPI.keyFromSecret = {
        name = "netbird-secret";
        key = "access-token";
      };
    };
  };
}
