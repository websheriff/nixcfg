{ config, ... }: {
  imports = [
    ../common
    ./configuration.nix
    ./hardware-configuration.nix
    ../../services
    ./secrets.nix
  ];

  nixpkgs.config.allowUnfree = true;


}
