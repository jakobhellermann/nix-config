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
      jetbrains.idea
      bitwarden-desktop
      firefox
      fuzzel
      jetbrains-mono
      signal-desktop
      vscode
      zed-editor
    ]
    ++ builtins.filter (pkg: lib.meta.availableOn pkgs.stdenv.hostPlatform pkg) systemDependentPackages;
}
