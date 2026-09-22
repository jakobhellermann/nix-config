{ config, pkgs, ... }:
{
  imports = [
    ../../shared.nix
    ../../modules/niri.nix
    ../../modules/steam.nix
    ./hardware.nix
    ./vpn.nix
    ./disko.nix
  ];

  security.pki.certificateFiles = [ ./sipgate-ca-root_2018-06-01.crt ];

  networking.hostName = "sipgatejj";

  users.users.sipgatejj = {
    isNormalUser = true;
    initialPassword = "initial";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
    ];
    openssh.authorizedKeys.keys = config.my.sshKeys;
  };
}
