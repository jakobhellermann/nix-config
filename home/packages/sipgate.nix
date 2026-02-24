{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # ktfmt
    ansible
    krew
    kubectl
    kubelogin
    maven
    postgresql
    slack
  ];
}
