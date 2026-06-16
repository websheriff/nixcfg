{ config, pkgs, inputs, ...  }: {

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
}
