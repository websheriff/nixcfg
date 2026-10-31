{ ... }: {

  services.k3s.autoDeployCharts.cert-manager = {
    name = "cert-manager";
    repo = "https://charts.jetstack.io";
    hash = "sha256-Hxomj9FkLXbQuf0WKq7ckZc6gbh9nlfA//JGAkzNKtQ=";
    targetNamespace = "cert-manager";
    createNamespace = true;
    version = "1.20.0";
    values = {
      installCRDs = true;
      extraArgs = [
        "--dns01-recursive-nameservers=1.1.1.1:53,9.9.9.9:53"
        "--dns01-recursive-nameservers-only"
      ];
    };
  };
}
