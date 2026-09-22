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

  services.speechd.enable = lib.mkOverride 1200 false;
}
