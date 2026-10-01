{ config, pkgs, ... }:
let
  username = "sipgatejj";
in
{
  imports = [
    ../../shared.nix
    ../../modules/niri.nix
    ../../modules/noctalia.nix
    ../../modules/steam.nix
    ./hardware.nix
    ./vpn.nix
    ./disko.nix
  ];

  virtualisation.containers.registries.settings = {
    registry = [
      # Artifactory serves images under a path prefix. search registries only accept hostnames, so this needs a prefix rewrite.
      {
        prefix = "registry.sipgate.net/minio/minio";
        location = "registry.sipgate.net/docker/minio/minio";
      }
    ];
    "unqualified-search-registries" = [
      "docker.io"
      "registry.sipgate.net"
    ];
  };

  security.pki.certificateFiles = [ ./sipgate-ca-root_2018-06-01.crt ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ username ];
  };

  networking.hostName = "sipgatejj";

  users.users.${username} = {
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
