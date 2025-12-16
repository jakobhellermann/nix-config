{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ansible
    colima
    krew
    ktfmt
    kubelogin
    maven
    postgresql
  ];
}
