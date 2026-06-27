{ ... }: {

  imports = [
    ./apps/forgejo
  ];

  services.k3s.manifests.cicd-ns.content = {
    apiVersion = "v1";
    kind = "Namespace";
    metadata = {
      name = "cicd";
    };
  };
}
