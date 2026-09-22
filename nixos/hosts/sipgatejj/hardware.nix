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

  # kernel 7.3-rc needed for CS35L57 speaker fix (spk-id-gpios EBUSY, thesofproject/sof#11152)
  boot.kernelPackages = pkgs.linuxPackages_testing;
  assertions = [
    {
      assertion = lib.versionOlder pkgs.linuxPackages_latest.kernel.version "7.3";
      message = "linuxPackages_latest is now 7.3+: switch boot.kernelPackages from linuxPackages_testing back to linuxPackages_latest and remove this assertion";
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Intel Arc B390 (Panther Lake): hardware video decode (VA-API)
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
  services.thermald.enable = true; # throttling
  services.fwupd.enable = true; # firmware updates
  services.power-profiles-daemon.enable = true; # CPU performance preferences - powerprofilesctl
}
