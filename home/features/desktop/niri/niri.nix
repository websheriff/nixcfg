{ config, lib, inputs, pkgs, ... }:
with lib; let
  cfg = config.features.desktop.niri;
in {
  options.features.desktop.niri.enable = mkEnableOption "enable niri";
  config = mkIf cfg.enable {

    programs.niri.enable = true;

    security.polkit.enable = true;
    security.pam.services.swaylock = {};
    services.gnome.gnome-keyring.enable = true;
    
    hjem.users.websheriff = {
      files = {
        ".config/niri/config.kdl".source = ./config.kdl;
      };
    };
  };
}
