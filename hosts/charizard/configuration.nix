{ config, lib, pkgs-unstable, inputs, ... }: {
  
  imports =
    [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "charizard";

  time.timeZone = "America/Chicago";

  environment.systemPackages = with pkgs-unstable; [
    wget
    helix
    git
    ghostty
    inputs.agenix.packages."${stdenv.hostPlatform.system}".default
  ];
  environment.variables.EDITOR = "helix";

  networking.networkmanager.enable = true;

  networking.nftables.enable = true;

  networking.firewall.allowedTCPPorts = [ 
  ];
  networking.firewall.allowedUDPPorts = [
  ];
  
  services.openssh.enable = true;

  hardware.graphics = {
    enable = true;
    enable32bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";

}

