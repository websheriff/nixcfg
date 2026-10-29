{
  config,
  lib,
  ...
}: {
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir -p /tmp
    mount -t btrfs -o subvol=/ /dev/vda /tmp
    if [ -e /tmp/@ ]; then
      echo "Cleaning root subvolume..."
      btrfs subvolume delete /tmp/@
    fi
    echo "Creating fresh root subvolume..."
    btrfs subvolume snapshot /tmp/@blank /tmp/@
    umount /tmp
  '';

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/db/sudo"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/network"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  services.openssh.hostKeys = [
    {
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];
}
