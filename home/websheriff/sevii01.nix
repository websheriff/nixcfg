{
  imports = [
    ../core
    ../features
    ./home.nix
  ];

  features = {
    cli = {
      fish.enable = false;
    };
  };
}
