{ pkgs, ... }: {

  imports = [
    ./home.nix
    #../core
    ../features/cli
    ../features/desktop
    ../ghostty.nix
    ../zen.nix
    #../vicinae.nix
    ../noctalia.nix
    ../mango.nix
  ];

  features = {
    cli = {
      fish.enable = true;
      starship.enable = true;
    };
  };

  home.packages = with pkgs; [
    prismlauncher
  ];

  stylix.targets.helix.enable = false;

  programs.helix = {
    settings = {
      theme = "ayu_evolve";
    };
  };

  xdg = {
    enable = true;
    userDirs.createDirectories = true;
  };

  xdg.configFile."niri/config.kdl".source = ../../hosts/charizard/niri/config.kdl;
}
