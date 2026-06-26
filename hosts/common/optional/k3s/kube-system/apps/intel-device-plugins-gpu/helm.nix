{ ... }: {
  services.k3s.autoDeployCharts.intel-device-plugins-gpu = {
    name = "intel-device-plugins-gpu";
    repo = "https://intel.github.io/helm-charts/";
    targetNamespace = "kube-system";
    createNamespace = false;
    version = "0.36.0";

    values = {
      sharedDevNum = 5;
    };
  };
}
