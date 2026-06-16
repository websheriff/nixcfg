{ pkgs, ...  }: {

  imports = [
   ./home.nix
   ../core
   ../features/cli
   ../features/desktop
  ];

  features = {
    cli = {
      fish.enable = true;
    };
  };

  home.packages = with pkgs; [
    prismlauncher
  ];

  xdg.configFile."niri/config.kdl".source = ../../hosts/charizard/niri/config.kdl;
}
