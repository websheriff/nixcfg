{ ... }: {
  services.k3s.autoDeployCharts.netbird-operator = {
    name = "netbird-operator";
    repo = "oci://ghcr.io/netbirdio/helm-charts/netbird-operator";
    hash = "sha256-9mUW6gNwoN2SWc/l0fW4svPNOulXLl8ijqKyeSOGgJE%3D";
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
