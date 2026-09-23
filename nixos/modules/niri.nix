{ pkgs, lib, ... }:
{
  programs.niri.enable = true;

  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  environment.systemPackages = with pkgs; [ xwayland-satellite ];

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
