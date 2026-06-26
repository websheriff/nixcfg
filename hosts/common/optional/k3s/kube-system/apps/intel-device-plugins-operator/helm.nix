{ ... }: {
  services.k3s.autoDeployCharts.intel-device-plugins-operator = {
    name = "intel-device-plugins-operator";
    repo = "https://intel.github.io/helm-charts";
    targetNamespace = "kube-system";
    createNamespace = false;
    version = "0.36.0";
  };
}
