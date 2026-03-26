{ ... }: {

  services.k3s.autoDeployCharts.metallb = {
    name = "metallb";
    repo = "https://metallb.github.io/metallb";
    hash = "sha256-J9t2HFrSUl/RMMkv4vLUUA+IcOQC/v48nLjTTYpxpww=";
    targetNamespace = "metallb-system";
    createNamespace = true;
    version = "0.15.3";
    values = {
      namespace = {
        labels = {
          "pod-security.kubernetes.io/enforce" = "privileged";
          "pod-security.kubernetes.io/audit" = "privileged";
          "pod-security.kubernetes.io/warn" = "privileged";
        };
      };
    };
  };
}
