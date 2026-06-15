{ ... }: {
  imports = [
    ../common
    ./niri
    ./noctalia
    ./cli/cli.nix
    ./configuration.nix
    ./disko.nix
    ./ghostty.nix
    ./steam.nix
    ./vicinae.nix
    ./zen.nix
  ];
}
