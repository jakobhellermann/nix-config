{ pkgs, ... }:
{
  imports = [
    ../../shared.nix
    ../../modules/steam.nix
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
