{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # ktfmt
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
