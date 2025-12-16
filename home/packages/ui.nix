{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bitwarden-desktop
    discord
    firefox
    fuzzel
    jetbrains-mono
    signal-desktop
    spotify
    vscode
    zed-editor
  ];
}
