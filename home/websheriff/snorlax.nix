{ ... }: {

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
			starship.enable = true;
		};	
	};
}
