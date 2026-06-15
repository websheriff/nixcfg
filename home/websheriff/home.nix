{ config, pkgs, ...  }: {

	imports = [
		../core
	];
	
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
}
