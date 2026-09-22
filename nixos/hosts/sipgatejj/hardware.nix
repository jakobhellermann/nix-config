{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "sd_mod"
    "thunderbolt"
  ];
  boot.initrd.kernelModules = [ "xe" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Panel Replay/Self-Refresh on the internal display causes noticeable input latency
  # Trade-off: slightly higher idle power draw.
  # TODO: investigate
  boot.kernelParams = [
    "xe.enable_psr=0"
    "xe.enable_panel_replay=0"
  ];

  # latest kernel https://github.com/NixOS/nixos-hardware/pull/1912/files
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Intel Arc B390 (Panther Lake): hardware video decode (VA-API)
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
  services.thermald.enable = true; # throttling
  services.fwupd.enable = true; # firmware updates
  services.power-profiles-daemon.enable = true; # CPU performance preferences - powerprofilesctl
}
