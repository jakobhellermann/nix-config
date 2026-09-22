{ pkgs, ... }:
{
  imports = [
    ../../shared.nix
    ./hardware.nix
    ./disko.nix
  ];

  networking.hostName = "sipgatejj";

  users.users.sipgatejj = {
    isNormalUser = true;
    initialPassword = "initial";
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
  };
}
