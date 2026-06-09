{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.local.ringo;
  tomlFormat = pkgs.formats.toml { };

  # Drop attrs whose value is null so they don't reach the TOML writer
  # (TOML has no null; omitting a key falls back to ringo's defaults).
  prune = filterAttrs (_: v: v != null);

  mkProfile =
    p:
    tomlFormat.generate "ringo-profile.toml" (
      prune {
        inherit (p)
          username
          password
          domain
          notify
          mwi
          ;
        display_name = p.displayName;
        transport = p.transport;
        outbound = p.outbound;
        stun_server = p.stunServer;
        media_enc = p.mediaEnc;
      }
      // optionalAttrs (p.customHeaders != [ ]) { custom_headers = p.customHeaders; }
    );
in
{
  options.local.ringo = {
    enable = mkEnableOption "ringo SIP softphone configuration";

    contacts = mkOption {
      description = "Contacts written to ~/.config/ringo/contacts.toml.";
      default = [ ];
      type =
        with types;
        listOf (submodule {
          options = {
            name = mkOption { type = str; };
            numbers = mkOption { type = listOf str; };
          };
        });
    };

    settings = mkOption {
      description = ''
        Global ringo.toml settings (picker, theme, baresip, contacts, hooks).
        Written to ~/.config/ringo/ringo.toml.
      '';
      default = { };
      type = tomlFormat.type;
    };

    profiles = mkOption {
      description = ''
        SIP profiles. Each entry is written to
        ~/.config/ringo/profiles/<name>/profile.toml. The sibling
        call_history file is left to ringo (only profile.toml is symlinked).
      '';
      default = { };
      type =
        with types;
        attrsOf (submodule {
          options = {
            username = mkOption { type = str; };
            password = mkOption { type = str; };
            domain = mkOption { type = str; };
            displayName = mkOption {
              type = nullOr str;
              default = null;
            };
            transport = mkOption {
              type = nullOr (enum [
                "udp"
                "tcp"
                "tls"
              ]);
              default = null;
            };
            outbound = mkOption {
              type = nullOr str;
              default = null;
            };
            stunServer = mkOption {
              type = nullOr str;
              default = null;
            };
            mediaEnc = mkOption {
              type = nullOr str;
              default = null;
            };
            notify = mkOption {
              type = bool;
              default = false;
            };
            mwi = mkOption {
              type = bool;
              default = true;
            };
            customHeaders = mkOption {
              description = "Ordered [key value] pairs added to every outgoing INVITE.";
              type = listOf (listOf str);
              default = [ ];
              example = [
                [
                  "X-Client-Correlation-ID"
                  "rj-u1-\${uuid}"
                ]
              ];
            };
          };
        });
    };
  };

  config = mkIf cfg.enable {
    home.file =
      optionalAttrs (cfg.contacts != [ ]) {
        ".config/ringo/contacts.toml".source = tomlFormat.generate "ringo-contacts.toml" {
          contacts = map (c: { inherit (c) name numbers; }) cfg.contacts;
        };
      }
      // optionalAttrs (cfg.settings != { }) {
        ".config/ringo/ringo.toml".source = tomlFormat.generate "ringo.toml" cfg.settings;
      }
      // mapAttrs' (
        name: p: nameValuePair ".config/ringo/profiles/${name}/profile.toml" { source = mkProfile p; }
      ) cfg.profiles;
  };
}
