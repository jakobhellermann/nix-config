{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "thunderbolt"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/500bd8bb-07d6-4c93-8618-f065d273e392";
    fsType = "btrfs";
    options = [
      "subvol=@data"
      "discard=async"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BCCE-F4C4";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-26539e54a634.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-27f8e13735dd.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-ae901adafc16.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-b48ef03ed825.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-bafd692bc025.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wwan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
