{ pkgs, ... }:
{
  imports = [
    ../../shared.nix
    ./hardware.nix
  ];

  networking.hostName = "jj";

  users.users.jakob = {
    isNormalUser = true;
    initialPassword = "initial";
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
  };
}
