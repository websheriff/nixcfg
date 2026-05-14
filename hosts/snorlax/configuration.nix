{ config, lib, pkgs, ... }: {
	
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
	boot.initrd.luks.devices = {
		cryptroot = {
			device = "/dev/disk/by-partlabel/luks";
			allowDiscards = true;
			preLVM = true;
		};
	};
	boot = {
		tmp = {
			useTmpfs = true;
			tmpfsSize = "50%";
		};
	};

	zramSwap = {
		enable = true;
		algorithm = "zstd";
		priority = 5;
		memoryPercent = 50;
	};

  networking.hostName = "snorlax";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
  
  environment.systemPackages = with pkgs; [
		git
		age
		sops
		helix
	];

	services.openssh.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11"; # Did you read the comment?

}

