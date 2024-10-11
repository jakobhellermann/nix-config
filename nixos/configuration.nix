{ config, lib, pkgs, ... }:

{
  nix = {
    # imports =
    #   [ # Include the results of the hardware scan.
    #     ./hardware-configuration.nix
    #   ];
    settings.experimental-features = [ "nix-command" "flakes" ];
    # channel.enable = false;
  };


  ## System
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  time.timeZone = "Europe/Berlin";
  networking.hostName = "sipgatejj";
  networking.networkmanager.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "de";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.users.jakob = {
    isNormalUser = true;
    initialPassword = "initial";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      firefox
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    grim
    slurp
    wl-clipboard
    mako
  ];
  environment.variables.EDITOR = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.sway = {
    enable = true;
  };


  # services.xserver.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";


  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.11"; # Did you read the comment?
}

