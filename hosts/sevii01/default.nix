{ ... }: {
  imports = [
    ../common
    ../common/optional/k3s
    ./configuration.nix
    ./hardware-configuration.nix
    ./disk-config.nix
    #./impermanence.nix
    ./secrets.nix
  ];
}
