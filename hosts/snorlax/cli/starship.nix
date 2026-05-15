{ config, lib, pkgs, ... }:
    programs.starship = {
     enable = true;
     enableFishIntegration = true;
     enableNushellIntegration = true;

     settings = pkgs.lib.importTOML ./jetpack.toml;
    };
    #move this
    home.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
    fonts.fontconfig.enable = true; 
  };
}
