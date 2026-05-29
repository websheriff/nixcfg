{ pkgs, inputs, ... }: {

  services.tuned.enable = true;
  services.upower.enable = true;

  hjem.users.websheriff = {
    files = {
      ".config/noctalia-shell/config.json".source = ./noctalia.json;
    };
  };
}
