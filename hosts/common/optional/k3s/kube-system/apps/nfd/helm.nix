{ ... }: {
  services.k3s.autoDeployCharts.nfd = {
    name = "node-feature-discovery";
    repo = "https://kubernetes-sigs.github.io/node-feature-discovery/charts";
    targetNamespace = "kube-system";
    createNamespace = false;
    version = "0.18.3";

    values = {
      master = {
        tolerations = [ { operator = "Exists"; } ];
      };
      worker = {
        tolerations = [ { operator = "Exists"; } ];
      };
    };
  };
}
