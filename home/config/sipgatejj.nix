{
  imports = [
    ./sipgatejj-shared.nix
    ../modules/firefox
    ../modules/dev.nix
    ../packages/base.nix
    ../packages/ui.nix
    ../packages/sipgate.nix
    ../packages/flakes.nix
  ];

  programs.vicinae = {
    enable = true;
    systemd.enable = true;
  };

  programs.fish.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

}
