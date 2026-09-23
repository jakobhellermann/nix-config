{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.diffpatch.packages.${pkgs.system}.default
  ];
}
