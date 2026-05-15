{ config, lib, pkgs, inputs, ... }:
with lib; let
  cfg = config.features.desktop.noctalia;
in {
  options.features.desktop.noctalia.enable = mkEnableOption "enable noctalia";
  config = mkIf cfg.enable {

    services.tuned.enabled = true;
    services.upower.enable = true;

    hjem.users.websheriff = {
      files = {
        ".config/noctalia-shell/config.json".source = ./noctalia.json;
      };
    };
  };
}
