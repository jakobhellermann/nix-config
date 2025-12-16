{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ansible
    colima
    krew
    ktfmt
    kubectl
    kubelogin
    maven
    postgresql
  ];
}
