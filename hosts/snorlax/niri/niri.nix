{ inputs, pkgs, ... }: {

  programs.niri.enable = true;

  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  services.gnome.gnome-keyring.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
      };
    };
  };
  
#  hjem.users.websheriff = {
#    files = {
#      ".config/niri/config.kdl".source = ./config.kdl;
#    };
#  };
}
