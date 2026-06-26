{ ... }: {
  services.k3s.autoDeployCharts.intel-device-plugins-operator = {
    name = "intel-device-plugins-operator";
    repo = "https://intel.github.io/helm-charts";
    hash = "sha256-guPqpOlyIGUOvXvS/1bd5JB4ZGiU6Cmzj9Y7iqfigx8=";
    targetNamespace = "kube-system";
    createNamespace = false;
    version = "0.36.0";
  };
}
