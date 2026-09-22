{
  imports = [
    ./sipgatejj-shared.nix
    ../modules/firefox
    ../modules/dev.nix
    ../packages/ui.nix
    ../packages/sipgate.nix
  ];

  programs.vicinae = {
    enable = true;
    systemd.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

}
