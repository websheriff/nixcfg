{ ... }: {
  services.k3s.autoDeployCharts.nfd = {
    name = "node-feature-discovery";
    repo = "https://kubernetes-sigs.github.io/node-feature-discovery/charts";
    hash = "sha256-DLWb1wRE09Qm/9U/0kKuQzEY1+u50q0y09uZvopSPhY=";
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
