{ ... }: {
  imports = [
    ./deployment.nix
    ./service.nix
    ./secret.nix
    ./ingress.nix
    ./database.nix
    ./pvc.nix
  ];
}
