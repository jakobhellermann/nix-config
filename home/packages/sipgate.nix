{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # ktfmt
    _1password-cli
    _1password-gui
    ansible
    krew
    kubectl
    kubelogin
    maven
    openjdk25_headless
    postgresql
    slack
  ];

  home.sessionVariables.JAVA_HOME = "${pkgs.openjdk25_headless.home}";
}
