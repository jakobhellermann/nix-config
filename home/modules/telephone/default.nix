{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.local.telephone;

  transportKey = {
    udp = "UDP";
    tcp = "TCP";
    tls = "TLS";
  };

  mkAccount = a: {
    Description = a.description;
    FullName = a.fullName;
    Domain = a.domain;
    Username = a.username;
    Registrar = a.registrar;
    Realm = "*";
    IPVersion = "4";
    Transport = transportKey.${a.transport};
    UseProxy = if a.proxyHost != null then 1 else 0;
    ProxyHost = if a.proxyHost != null then a.proxyHost else "";
    ProxyPort = 0;
    ReregistrationTime = 0;
    SIPAddress = "";
    PlusCharacterSubstitutionString = "00";
    SubstitutePlusCharacter = 0;
    UpdateContactHeader = true;
    UpdateSDP = true;
    UpdateViaHeader = true;
    UUID = a.uuid;
  };

  accountsJson = pkgs.writeText "telephone-accounts.json" (
    builtins.toJSON (map mkAccount cfg.accounts)
  );

  # Write the managed account definitions into Telephone's prefs while leaving
  # AccountEnabled to the user: existing accounts keep their current state
  # (matched by UUID), new ones default to disabled. Never flips a toggle.
  mergeScript = pkgs.writeText "telephone-merge-accounts.py" ''
    import json, plistlib, subprocess, sys

    domain = "com.tlphn.Telephone"
    accounts = json.load(open(sys.argv[1]))

    enabled = {}
    try:
        raw = subprocess.run(
            ["/usr/bin/defaults", "export", domain, "-"],
            capture_output=True, check=True,
        ).stdout
        for a in plistlib.loads(raw).get("Accounts", []):
            if "UUID" in a:
                enabled[a["UUID"]] = bool(a.get("AccountEnabled", False))
    except Exception:
        pass

    for a in accounts:
        a["AccountEnabled"] = enabled.get(a["UUID"], False)

    xml = plistlib.dumps(accounts).decode()
    subprocess.run(["/usr/bin/defaults", "write", domain, "Accounts", xml], check=True)
  '';
in
{
  options.local.telephone = {
    enable = mkEnableOption "Telephone.app account provisioning";

    accounts = mkOption {
      description = ''
        Accounts written into Telephone's preferences (the `Accounts` array of
        com.tlphn.Telephone). Only the `Accounts` key is managed; global settings
        and window state are left untouched. Passwords are NOT managed: enter each
        once in Telephone so the app owns its keychain items (external
        provisioning always triggers a keychain prompt).
      '';
      default = [ ];
      type =
        with types;
        listOf (
          submodule (
            { config, ... }:
            {
              options = {
                description = mkOption { type = str; };
                fullName = mkOption {
                  type = str;
                  default = config.description;
                };
                username = mkOption { type = str; };
                domain = mkOption { type = str; };
                registrar = mkOption {
                  type = str;
                  default = "";
                };
                proxyHost = mkOption {
                  type = nullOr str;
                  default = null;
                };
                transport = mkOption {
                  type = enum [
                    "udp"
                    "tcp"
                    "tls"
                  ];
                  default = "tcp";
                };
                uuid = mkOption { type = str; };
              };
            }
          )
        );
    };
  };

  config = mkIf (cfg.enable && cfg.accounts != [ ]) {
    home.activation.telephoneAccounts = hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${pkgs.python3}/bin/python3 ${mergeScript} ${accountsJson}
    '';
  };
}
