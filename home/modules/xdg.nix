{ config, ... }:
{
  xdg.enable = true;

  home.sessionVariables.LESSHISTFILE = "${config.xdg.stateHome}/less_history";
}
