{...}: {
  imports = [
    ../common
    ./configuration.nix
    ./hardware-configuration.nix
    ./disko.nix
    ./pangolin.nix
    #./impermanence.nix
  ];
}
