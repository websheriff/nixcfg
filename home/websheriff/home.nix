{ config, pkgs, ...  }:

{
	home.username = "websheriff";
	home.homeDirectory = "/home/websheriff";
	programs.git.enable = true;
	home.stateVersion = "25.11";

	home.file.".config/nvim".source = ../common/config/nvim;

	home.packages = with pkgs; [
		git
    neovim
		ripgrep
		nil
		nixpkgs-fmt
		nodejs
		gcc
	];

}
