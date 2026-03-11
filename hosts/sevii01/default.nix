{ config, ... }: {
  imports = [
    ../common
    ./configuration.nix
    ./hardware-configuration.nix
    ./disk-config.nix
    #./impermanence.nix
    ./secrets.nix
    ../common/core
  ];

  nixpkgs.config.allowUnfree = true;


}
