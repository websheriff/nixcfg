let
  disk1 = "/dev/nvme0n1";
  disk2 = "/dev/nvme1n1";
in
{
  disko.devices = {
    disk = {
      ${disk1} = {
        device = "${disk1}";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "EFI";
              name = "ESP";
              size = "1024M";
              type = "EF00" ;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              label = "luks";
              content = {
                type = "luks";
                name = "cryptroot";
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
          };
        };
      };
      ${disk2} = {
        device = "${disk2}";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "EFI-fallback";
              name = "ESP";
              size = "1024M";
              type = "EF00" ;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot-fallback";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              label = "luks-fallback";
              content = {
                type = "luks";
                name = "cryptroot-fallback";
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        mode = "mirror";
        options = {
          ashift = "12";
          autotrim = "on";
        };
        rootTmpfs = true;
        mountpoint = "none";

        datasets = {
          "local" = {
            type = "zfs_dataset";
            options.mountpoint = "none";
          };
          "local/root" = {
            type = "zfs_dataset";
            mountpoint = "/";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "false";
            };

            postCreateHook = ''
              zfs snapshot zroot/local/root@clean
            '';
          };
          "local/nix" = {
            type = "zfs_dataset";
            mountpoint = "/nix";
            options = {
              mountpoint = "legacy";
              atime = "off";
              nodump = "on";
              "com.sun:auto-snapshot" = "false";
            };
          };
          "safe" = {
            type = "zfs_dataset";
            options.mountpoint = "none";
          };
          "safe/home" = {
            type = "zfs_dataset";
            mountpoint = "/home";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "safe/persist" = {
            type = "zfs_dataset";
            mountpoint = "/persist";
            options = {
              mountpoint = "legacy";
            };
          };
        };
      };
    };
  };
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/nix".neededForBoot = true;
}
