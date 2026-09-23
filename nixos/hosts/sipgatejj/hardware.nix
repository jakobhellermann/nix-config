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

  # CS35L56 spk-id-gpios EBUSY: all four SoundWire amps reference the same
  # host GPIO in ACPI; a competing exclusive claim makes gpiod_get_array_optional()
  # return -EBUSY and the driver treats that as fatal, so no ALSA card is
  # registered at all (dummy output in wpctl). Patched replacement modules make
  # the driver tolerate -EBUSY and continue without the speaker ID, exactly
  # like it already does for the shared reset GPIO. Still broken in v7.3-rc4;
  # no fix queued upstream. See cs35l56-ebusy-fix/ and thesofproject/sof#11152.
  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ./cs35l56-ebusy-fix { })
  ];

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
