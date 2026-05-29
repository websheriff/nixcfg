{ config, lib, pkgs, ... }: {
    programs.starship = {
     enable = true;
     enableFishIntegration = true;
     enableNushellIntegration = true;

     settings = pkgs.lib.importTOML ./jetpack.toml;
    };
}
