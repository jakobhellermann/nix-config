{ ... }:
{
  imports = [
    ./modules/ssh-keys.nix
    ./modules/tailscale.nix
    ./packages.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nix.channel.enable = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.timeout = 1;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.useTmpfs = true;

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  services.resolved.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "de";
  };

  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  security.polkit.enable = true;
  environment.variables.EDITOR = "nvim";

  environment.sessionVariables.PKG_CONFIG_PATH =
    "$HOME/.nix-profile/lib/pkgconfig:" + "$HOME/.nix-profile/share/pkgconfig";

  programs.fish.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  security.pam.services.sudo.nodelay = true;

  services.libinput.enable = true;
  # services.blueman.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  # services.gnome.gnome-keyring.enable = true;

  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.05";
}
