{ pkgs, ... }:
{
  imports = [
    ../shared.nix
    ../modules/dock
  ];
  home.packages = with pkgs; [
    uutils-coreutils-noprefix
    # dockutil
  ];

  local = {
    dock.enable = false;
    dock.entries = [
      { path = "/Applications/Zen.app"; }
      { path = "/Applications/Discord.app"; }
      { path = "/Applications/Slack.app"; }
      { path = "/Applications/Zed.app"; }
      { path = "/Applications/Ghostty.app"; }
      { path = "/Users/sipgatejj/Applications/IntelliJ IDEA Ultimate.app"; }
      {
        path = "/Users/sipgatejj/Downloads";
        section = "others";
      }
    ];
  };
}
