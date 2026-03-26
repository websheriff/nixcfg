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
    };
  };
}
