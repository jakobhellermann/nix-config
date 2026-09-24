{ pkgs, lib, ... }@args:
let
  systemDependentPackages = with pkgs; [
    discord
    spotify
    wl-clipboard
  ];
in
{
  nixpkgs.config.allowUnfree = true;

  programs.foot = {
    enable = true;
    server.enable = true;
  };

  home.packages =
    with pkgs;
    [
      awww
      bitwarden-desktop
      brightnessctl
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
      (import ./build/cogfly.nix args)
    ]
    ++ builtins.filter (pkg: lib.meta.availableOn pkgs.stdenv.hostPlatform pkg) systemDependentPackages;
}
