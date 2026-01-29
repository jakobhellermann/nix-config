{ pkgs, ... }:
{
  imports = [
    ../shared.nix
    ../packages/base.nix
    ../packages/ui.nix
  ];
}
