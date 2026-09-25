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

  # zen ships its own NSS, so it doesn't see the system CA bundle; harmless for firefox
  programs.firefox.policies.Certificates.Install = [
    "${../../nixos/hosts/sipgatejj/sipgate-ca-root_2018-06-01.crt}"
  ];

  programs.fish.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

}
