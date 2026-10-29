{
  imports = [
    ../core/sops.nix
    ../features/cli
    ./home.nix
  ];

  features = {
    cli = {
      fish.enable = false;
      nushell.enable = false;
      starship.enable = false;
    };
  };
}
