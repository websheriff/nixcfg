{ config, lib, pkgs, inputs, ... }: 
with lib; let
  cfg = config.extraServices.podman;
in {
  
  imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

  options.extraServices.podman.enable = mkEnableOption "enable podman";

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
          flags = [
            "--filter=until=24h"
            "--filter=label!=important"
          ];
        };
      };
    };

    systemd.services."podman-auto-update".enable = true;

    environment.systemPackages = with pkgs; [
      podman-compose
    ];
  };
}
