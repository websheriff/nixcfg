{ inputs, pkgs, ... }: {

  programs.niri.enable = true;

  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  services.gnome.gnome-keyring.enable = true;
}
