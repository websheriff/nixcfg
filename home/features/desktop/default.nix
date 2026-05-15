{ pkgs, ... }: {

  imports = [
    ./niri
    ./noctalia
  ];

  #additional pkgs
  home.packages = with pkgs; [
    signal-desktop
    bitwarden-desktop
  ];

  
}
