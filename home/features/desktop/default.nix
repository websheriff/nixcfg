{ pkgs, ... }: {

  imports = [
  ];

  #additional pkgs
  home.packages = with pkgs; [
   # signal-desktop
   # bitwarden-desktop
  ];

  
}
