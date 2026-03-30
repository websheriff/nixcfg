{ ... }: {

  services.k3s.manifests.metallb.content = [
    {
      apiVersion = "v1";
      kind = "Namespace";
      metadata = {
        name = "metallb-system";
        labels = {
          "pod-security.kubernetes.io/enforce" = "privileged";
          "pod-security.kubernetes.io/audit" = "privileged";
          "pod-security.kubernetes.io/warn" = "privileged";
        };
      };
    }
    {
      apiVersion = "helm.cattle.io/v1";
      kind = "HelmChart";
      metadata = {
        name = "metallb";
        namespace = "kube-system";
      };
      spec = {
        chart = "metallb";
        repo = "https://metallb.github.io/metallb";
        hash = "sha256-J9t2HFrSUl/RMMkv4vLUUA+IcOQC/v48nLjTTYpxpww=";
        targetNamespace = "metallb-system";
        createNamespace = false;
        version = "0.15.3";
      };
    }
  ];
}
