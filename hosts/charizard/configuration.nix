{ config, lib, inputs, ... }: {
  
  imports =
    [];

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
  };

  networking = {
    hostName = "charizard";
    hostId = "1eb3da56";
    
    networkmanager.enable = true;
    
    nftables.enable = true;
    
    firewall = {
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  time.timeZone = "America/Chicago";

  environment.systemPackages = with pkgs; [
    sbctl #Required for Secure Boot
    wget
    helix
    git
    libreoffice
    nemo-with-extensions
    nemo-preview
    loupe
    papers
  ];

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
    enable32bit = true;
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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";

}

