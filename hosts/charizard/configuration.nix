{ inputs, pkgs, ... }: {

  imports = [
    inputs.noctalia-greeter.nixosModules.default
    inputs.mangowm.nixosModules.mango
  ];

  boot = {
    loader = {
      limine.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    initrd = {
      luks = {
        devices = {
          "cryptroot" = {
            device = "/dev/disk/by-partlabel/luks";
          };
          "cryptroot-fallback" = {
            device = "/dev/disk/by-partlabel/luks-fallback";
            tryEmptyPassphrase = true;
          };
        };
      };
    };

    zfs = {
      devNodes = "/dev/disk/by-id";
      forceImportRoot = false;
    };
  };

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  fileSystems."/media/games" = {
    device = "/dev/disk/by-uuid/dfa78f86-5bde-4a44-b6c1-c03881060910";
    fsType = "btrfs";
  };

  networking = {
    hostName = "charizard";
    hostId = "1eb3da56";

    networkmanager.enable = true;

    nftables.enable = true;

    firewall = {
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  time.timeZone = "America/Chicago";

  environment.systemPackages = with pkgs; [
    sbctl # Required for Secure Boot
    wget
    helix
    git
    libreoffice
    nemo-with-extensions
    nemo-preview
    loupe
    papers
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    sops
    xwayland-satellite
    wl-clipboard
  ];

  users.users.websheriff.packages = with pkgs; [
    discord-ptb
    signal-desktop
  ];

  programs.noctalia-greeter = {
    enable = true;
    package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;

    greeter-args = "--session niri";
  };

  xdg = {
    mime.defaultApplications = {
      "inode/directory" = [ "nemo.desktop" ];
      "application/x-gnome-saved-search" = [ "nemo.desktop" ];
    };
  };

  services.gvfs.enable = true;

  environment.variables.EDITOR = "helix";

  services.openssh.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.11";

}
