{ ...  }: {

  imports = [
   ./home.nix
   ../core
   ../features/cli
   ../features/desktop
  ];

  features = {
    cli = {
      fish.enable = true;
      nushell.enable = false;
      starship.enable = false;
      secrets.enable = true;
    };
  };

  home.packages = with pkgs; [
    prismlauncher
  ];

  users.users.websheriff.packages = with pkgs; [
    discord-ptb
    signal-desktop
    bitwarden-desktop
  ];
}
