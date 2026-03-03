{ config, ... }: {
  imports = [
    ../common
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;


}
