{ config, pkgs, ... }:
{
  imports = [
    ../../shared.nix
    ../../modules/niri.nix
    ./hardware.nix
    ./vpn.nix
    ./disko.nix
  ];

  networking.hostName = "sipgatejj";

  users.users.sipgatejj = {
    isNormalUser = true;
    initialPassword = "initial";
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = config.my.sshKeys;
  };
}
