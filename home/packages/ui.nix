{ pkgs, lib, ... }:
let
  systemDependentPackages = with pkgs; [
    discord
    spotify
    wl-clipboard
  ];
in
{
  nixpkgs.config.allowUnfree = true;

  home.packages =
    with pkgs;
    [
      awww
      bitwarden-desktop
      brightnessctl
      firefox
      foot
      fuzzel
      fyi
      gale
      ghostty
      jetbrains-mono
      jetbrains.idea
      jetbrains.rider
      playerctl
      signal-desktop
      swayosd
      vesktop
      vicinae
      waybar
      zed-editor
    ]
    ++ builtins.filter (pkg: lib.meta.availableOn pkgs.stdenv.hostPlatform pkg) systemDependentPackages;
}
