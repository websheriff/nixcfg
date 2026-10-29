{pkgs, ...}: {
  imports = [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    priority = 5;
    memoryPercent = 50;
  };

  networking.hostName = "galar";

  environment.systemPackages = with pkgs; [
    age
    sops
    git
    ghostty
    yazi
    wget
  ];
  environment.variables = {
    EDITOR = "nvim";
  };

  users.manageLingering = true;
  users.users.pangolin = {
    isSystemUser = true;
    group = "pangolin";
    linger = true;
    home = "/var/lib/pangolin";
    createHome = true;
    autoSubUidGidRange = true;
  };

  users.groups.pangolin = {};

  networking = {
    networkmanager.enable = false;
    useDHCP = false;

    interfaces.ens3 = {
      useDHCP = false;

      ipv4.addresses = [
        {
          address = "152.53.209.83";
          prefixLength = 22;
        }
      ];

      ipv6.addresses = [
        {
          address = "2a0a:4cc0:2000:c8bf::";
          prefixLength = 64;
        }
      ];
    };

    defaultGateway = "152.53.208.1";

    nameservers = [
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
    ];

    #nftables.enable = true;

    firewall = {
      enable = true;

      allowedTCPPorts = [
        443
      ];
      allowedUDPPorts = [
        51820
        21820
      ];
    };
  };

  services.resolved = {
    enable = true;

    settings.Resolve = {
      DNSOverTLS = true;
    };
  };

  services.xserver.videoDrivers = ["i915"];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  services.openssh.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.11";
}
