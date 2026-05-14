{ config, lib, ... }: {
	boot.initrd.systemd = {
		enabled = true;
		services.rollback = {
			description = "Rollback BTRFS root subvol to clean state";
			wantedBy = ["initrd.target"];
			after = ["systemd-cryptsetup@enc.service"];
			before = ["sysroot.mount"];
			unitConfig.DefaultDependencies = "no";
			serviceConfig.type = "oneshot";
			script = ''
    		mkdir -p /mnt
    			
				mount -o subvol=/ /dev/mapper/enc /mnt

				btrfs subvolume list -o /mnt/root |
					cut -f9 -d' ' |
					while read subvolume; do
						echo "deleting /$subvolume subvol..."
						btrfs subvolume delete "/mnt/$subvolume"
					done &&
					echo "deleting /root subvol..." &&
					btrfs subvolume delete /mnt/root
				echo "restoring clean /root subvol..."
				btrfs subvolume snapshot /mnt/root-clean /mnt/root

				umount /mnt
			'';
		};
	};
  
 	preservation = {
		enable = true;
	
		preserveAt."/persist" = {
			directories = [
				"/etc/nixos"
				"/etc/NetworkManager/system-connections"
				"/var/lib/bluetooth"
				"/var/db/sudo"
				{
					directory = "/var/lib/nixos";
					inInitrd = true;
				}
			];
		
			files = [
				{ 
					file = "/etc/machine-id";
					inInitrd = true;
				}
				{
					file = "/etc/ssh/ssh_host_rsa_key";
					how = "symlink";
					configureParent = true;
				}
				{
					file = "/etc/ssh/ssh_host_rsa_key.pub";
					how = "symlink";
					configureParent = "true";
				}
				{
					file = "/etc/ssh/ssh_host_ed25519_key";
					how = "symlink";
					configureParent = true;
				}
				{
					file = "/etc/ssh/ssh_host_ed25519_key.pub";
					how = "symlink";
					configureParent = true;
				}
			];
		};
	};
}
