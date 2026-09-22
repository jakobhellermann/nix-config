{
  config,
  lib,
  ...
}:

let
  mkUuid =
    s:
    let
      h = builtins.hashString "md5" s;
      seg = start: len: lib.substring start len h;
    in
    "${seg 0 8}-${seg 8 4}-${seg 12 4}-${seg 16 4}-${seg 20 12}";

  # Map a normalised ringo profile onto a Telephone account. Telephone can't
  # express media_enc / custom headers / mwi, so those are dropped.
  mkTelephoneAccount = name: p: {
    description = p.displayName;
    fullName = p.displayName;
    inherit (p) username domain;
    transport = p.transport;
    proxyHost =
      if p.outbound == null then
        null
      else
        lib.head (lib.splitString ";" (lib.removePrefix "sip:" p.outbound));
    uuid = mkUuid p.username;
  };
in
{
  imports = [
    ./sipgatejj-shared.nix
    ../modules/dock
    ../modules/telephone
    ../packages/sipgate.nix
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

    telephone = {
      enable = true;
      accounts = lib.mapAttrsToList mkTelephoneAccount config.local.ringo.profiles;
    };
  };
}
