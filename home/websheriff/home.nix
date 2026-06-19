{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{

  #	imports = [
  #		inputs.sops-nix.homeManagerModules.sops
  #	];

  #	sops = {
  #		age.keyFile = "/home/websheriff/.config/sops/age/keys.txt";
  #
  #		defaultSopsFile = ../../secrets.yaml;
  #
  #		secrets."users/websheriff/private_key" = {
  #			path = "/home/websheriff/.ssh/id_ed25519";
  #		};
  #	};

  home.username = "websheriff";
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "websheriff";
        email = "websheriff@fastmail.com";
      };
      init.defaultBranch = "master";
    };
  };

  stylix.targets.helix.enable = false;

  programs.helix = {
    enable = true;
    settings = {
      editor = {
        true-color = true;
      };
    };

    extraPackages = with pkgs; [
      nixd
    ];

    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt;
      }
    ];
  };
}
