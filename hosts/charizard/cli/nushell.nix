{ config, lib, ... }:
with lib; let
  cfg = config.features.cli.nushell;
in {
  options.features.cli.nushell.enable = mkEnableOption "enable nushell";
  config = mkIf cfg.enable {

    programs.nushell = {
      enable = true;
      shellAliases = {
        k = "kubectl";
        vi = "hx";
        vim = "hx";
        nano = "hx";
      };
    };
  };
}
