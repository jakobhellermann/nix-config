{
  imports = [
    ./sipgatejj-shared.nix
    ../packages/ui.nix
    ../packages/sipgate.nix
  ];

  programs.vicinae = {
    enable = true;
    systemd.enable = true;
  };
}
