{ ... }: {
  imports = [
    ./deployment.nix
    ./service.nix
    ./pvc.nix
    ./ingress.nix
  ];
}
