{ ... }: {
  imports = [
    ../common
    ./niri
    ./noctalia
    #    ./cli/cli.nix
    ./cli/fish.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ./disko.nix
    ./steam.nix
    ./stylix.nix
  ];
}
