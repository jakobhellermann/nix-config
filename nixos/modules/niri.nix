{ pkgs, lib, ... }:
{
  programs.niri.enable = true;

  environment.systemPackages = [ pkgs.xwayland-satellite ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  # Backlight write access for brightnessctl
  services.udev.packages = [ pkgs.brightnessctl ];

  services.speechd.enable = lib.mkOverride 1200 false;
}
