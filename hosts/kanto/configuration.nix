{ config, lib, pkgs, ... }: {
  
  imports =
    [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sevii01";

  time.timeZone = "America/Chicago";

  users.users.websheriff = {
      isNormalUser = true;
      extraGroups = [ "wheel" "minecraft" ];
      packages = with pkgs; [
        tree
	      neovim
      ];
    };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    ghostty
    fosrl-newt
  ];
  environment.variables.EDITOR = "nvim";

  networking = {
    usePredictableInterfaceNames = true;
    networkmanager.enable = false;
  };

  systemd.network.enable = true;
  networking.useDHCP = false;
  systemd.network = {
    netdevs = {
      "20-vlan5" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan5";
        };
        vlanConfig.Id = 5;
      };
      "20-vlan50" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan50";
        };
        vlanConfig.Id = 50;
      };
      "20-vlan100" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan100";
        };
        vlanConfig.Id = 100;
      };
    };

    networks = {
      "10-eno1" = {
        enable = true;
        matchConfig.Name = "eno1";
        address = [ "10.5.5.15/24" ];
        gateway = [ "10.5.5.1" ];
        dns = [ "10.5.5.1" ];
        vlan = [
          "vlan50"
          "vlan100"
        ];
        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "no";
      };
      "30-vlan50" = {
        matchConfig.Name = "vlan50";
        DHCP = "ipv4";
        linkConfig.RequiredForOnline = "no";
      };
      "30-vlan100" = {
        matchConfig.Name = "vlan100";
        DHCP = "ipv4";
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  networking.nftables.enable = true;

  networking.firewall.allowedTCPPorts = [ 
    25565
  ];
  networking.firewall.allowedUDPPorts = [
  ];
  
  services.openssh.enable = true;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.vanilla-latest = {
      enable = true;
      autoStart = true;
      jvmOpts = "-Xmx6G -Xms6G";

      package = pkgs.paperServers.paper;

      serverProperties = {
        difficulty = 2;
        gamemode = 0;
        white-list = true;
      };
      operators = {
        supreme_loser = "3443b3e3-709b-4e9c-bc70-50806be0eb30";
      };
      whitelist = {
        supreme_loser = "3443b3e3-709b-4e9c-bc70-50806be0eb30";
        BrockyDiesel = "b866d032-84f1-4ce2-a221-d659901c4757";
      };
    };
  };

  services.newt = {
    enable = true;
    environmentFile = config.age.secrets.secret-newtMC.path;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";

}

