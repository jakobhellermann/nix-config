{ pkgs, lib, ... }:
let
  systemDependentPackages = with pkgs; [
    discord
    spotify
  ];
in
{
  nixpkgs.config.allowUnfree = true;

  home.packages =
    with pkgs;
    [
      bitwarden-desktop
      firefox
      fuzzel
      jetbrains-mono
      jetbrains.idea
      signal-desktop
      zed-editor
    ]
    ++ builtins.filter (pkg: lib.meta.availableOn pkgs.stdenv.hostPlatform pkg) systemDependentPackages;
}
