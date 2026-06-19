{ ... }: {
  imports = [
    ../common
    ./niri
    ./noctalia
#    ./cli/cli.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ./disko.nix
    ./steam.nix
    ./stylix.nix
  ];
}
