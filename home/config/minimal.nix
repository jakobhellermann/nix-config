{
  pkgs,
  ...
}:
{
  imports = [
    ../shared.nix
  ];

  home.stateVersion = "26.11";

  # forward coding.sipgate.ai:443 over sipgatejj
  systemd.user.services.coding-proxy-tunnel = {
    Unit = {
      Description = "sipgate coding proxy tunnel";
      StartLimitIntervalSec = 0;
    };
    Service = {
      ExecStart = "${pkgs.openssh}/bin/ssh -N -L 127.0.0.1:443:coding.sipgate.ai:443 -i %h/.ssh/id_ed25519 -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes sipgatejj@sipgatejj";
      Restart = "always";
      RestartSec = "10s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
