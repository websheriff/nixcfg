{ ... }: {
  services.k3s.autoDeployCharts.intel-device-plugins-gpu = {
    name = "intel-device-plugins-gpu";
    repo = "https://intel.github.io/helm-charts/";
    hash = "sha256-xh4QWuIeXWzq1gXG0zfw6uTpJFKmSnS5juj2s3M3YWE="
    targetNamespace = "kube-system";
    createNamespace = false;
    version = "0.36.0";

    values = {
      sharedDevNum = 5;
    };
  };
}
