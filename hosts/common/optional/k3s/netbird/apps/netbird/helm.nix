{ ... }: {
  services.k3s.autoDeployCharts.netbird-operator = {
    name = "netbird-operator";
    repo = "oci://ghcr.io/netbirdio/helm-charts/netbird-operator";
    hash = "sha256-YbxJ6Nd1mA9SomYrTFZV8Xf/PovnGJaUzmpXCUg1mdE=";
    targetNamespace = "netbird";
    createNamespace = false;
    version = "0.8.0";
    values = {
      netbirdAPI.keyFromSecret = {
        name = "netbird-secret";
        key = "access-token";
      };
    };
  };
}
