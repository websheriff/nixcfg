{ config, lib, pkgs, inputs, ... }: {
	
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
		inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
		swaylock
		swayidle
		xwayland-satellite
		git
		age
		sops
		helix
		ghostty
	];

	services.openssh.enable = true;

	hardware.bluetooth.enable = true;
	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11"; # Did you read the comment?

}

