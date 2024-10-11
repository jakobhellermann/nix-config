# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0e8aff92-149e-4137-8eda-9e04822f7ad8";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/.snapshots" =
    { device = "/dev/disk/by-uuid/0e8aff92-149e-4137-8eda-9e04822f7ad8";
      fsType = "btrfs";
      options = [ "subvol=@.snapshots" ];
    };

  fileSystems."/var/cache/pacman/pkg" =
    { device = "/dev/disk/by-uuid/0e8aff92-149e-4137-8eda-9e04822f7ad8";
      fsType = "btrfs";
      options = [ "subvol=@pkg" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/0e8aff92-149e-4137-8eda-9e04822f7ad8";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/0e8aff92-149e-4137-8eda-9e04822f7ad8";
      fsType = "btrfs";
      options = [ "subvol=@log" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/BCCE-F4C4";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/var/lib/docker/overlay2/6fe978a5dfb4319c8f63d630c552358c15793167e92e5c7fd246a9c3f9519e01/merged" =
    { device = "overlay";
      fsType = "overlay";
    };

  fileSystems."/var/lib/docker/overlay2/fe1fa9fce9e10fbc12fbad66822c69ebdab1301f71fa1cb851a91adae02d22bc/merged" =
    { device = "overlay";
      fsType = "overlay";
    };

  fileSystems."/var/lib/docker/overlay2/cd4980a32a9d8cbbd6586b4b2d28073fc78b9ec9b31b8a0f8a6220ba3c65d272/merged" =
    { device = "overlay";
      fsType = "overlay";
    };

  fileSystems."/var/lib/docker/overlay2/d35b5626e9ee91d9e7dbb7ba119f080bd2804913707da210d8709b8c8dd337e1/merged" =
    { device = "overlay";
      fsType = "overlay";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-583323b87895.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-9b93c9aa482f.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-a23afecade2d.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-c550b6ed697d.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.tun0.useDHCP = lib.mkDefault true;
  # networking.interfaces.veth399b80a.useDHCP = lib.mkDefault true;
  # networking.interfaces.veth826b2a5.useDHCP = lib.mkDefault true;
  # networking.interfaces.vethb00eea2.useDHCP = lib.mkDefault true;
  # networking.interfaces.vethff986e0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wwan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
