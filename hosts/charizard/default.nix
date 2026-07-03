{ ... }: {
  imports = [
    ../common
    ./niri
    #./noctalia
    ../dms.nix
    #    ./cli/cli.nix
    ./cli/fish.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ./disko.nix
    ./steam.nix
    ./stylix.nix
    ../common/thunar.nix
  ];
}
