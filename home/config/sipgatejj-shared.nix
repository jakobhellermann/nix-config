{ pkgs, lib, ... }:
let
  mkDevProfile =
    {
      name,
      username,
      password,
      prefix,
      domain ? "sipgate.de",
      outbound ? "sip:sip.dev.sipgate.de;transport=tls",
      preferredIdentity ? null,
    }:
    {
      displayName = name;
      inherit
        username
        password
        domain
        outbound
        ;
      transport = "tls";
      mediaEnc = "srtp-mand";
      notify = false;
      mwi = true;
      customHeaders = [
        [
          "X-Client-Correlation-ID"
          "${prefix}-\${uuid}"
        ]
      ]
      ++ (
        if preferredIdentity != null then
          [
            [
              "P-Preferred-Identity"
              "<sip:${preferredIdentity}@${domain}>"
            ]
          ]
        else
          [ ]
      );
    };

  devProfiles = [
    {
      name = "(devneo) User 1";
      username = "1126226e0";
      password = "abrK9wm3kwE4";
      prefix = "rj-u1";
      number = "+4951136059299";
    }
    {
      name = "(devneo) Voiza 1";
      username = "1126226e1";
      password = "FnLq5XsTbDow";
      prefix = "rj-v1";
      number = "+4951136059291";
    }
    {
      name = "(devneo) Voiza 2";
      username = "1126226e2";
      password = "jB67Yc5bD64B";
      prefix = "rj-v2";
      number = "+4951136059292";
    }
    {
      name = "(devneo) Voiza 3";
      username = "1126226e4";
      password = "JRDE6VbNnURQ";
      prefix = "rj-v3";
      number = "+4951136059293";
    }
    {
      name = "(devneo) Voiza Local 1 e6";
      username = "1126226e6";
      password = "HntjdBDtFYUN";
      prefix = "rj-vl1-e6";
      number = "+4989381698196";
    }
    {
      name = "(devneo) Voiza Local 2 e7";
      username = "1126226e7";
      password = "jC6BnkDkxMxh";
      prefix = "rj-vl1-e7";
      number = "+4989381698197";
    }
    {
      name = "(devneo-uk) Voiza 1";
      username = "1127337e1";
      password = "LzFcgb54DFtd";
      prefix = "rj-uk-v1";
      domain = "sipgate.co.uk";
      outbound = "sip:sip.dev.sipgate.co.uk;transport=tls";
    }
    {
      name = "(devneo2) Voiza 1";
      username = "1126825e1";
      password = "2UDZQVKXcDyJ";
      prefix = "rj2-v1";
      number = "+4971146059791";
    }
    {
      name = "(devneo2) Voiza Local2Dev";
      username = "1126825e4";
      password = "tpPsGCZHK2Z6";
      prefix = "rj2-vl";
      number = "+4971146059791";
    }
    {
      name = "(aipg) Voiza 1";
      username = "1127298e1";
      password = "HmqRp3n3ctkw";
      prefix = "jai-v1";
      number = "+4940228172991";
    }
    {
      name = "(aipg) w1 Ben";
      username = "1127298e5";
      password = "8kn4phgv9DbX";
      prefix = "jai-w1";
      number = "+4940228172999";
    }
    {
      name = "(aipg) AI Phone 1";
      username = "1127298e0";
      password = "7D7Pc8ogxU9s";
      prefix = "jai-p1";
    }
    {
      name = "(aipg) AI Phone 2";
      username = "1127298e17";
      password = "yS3kLpcc6EG5";
      prefix = "jai-p2";
    }
    {
      name = "legacy";
      username = "1109964e5";
      password = "M1tUjHaXjPmh";
      prefix = "j-l";
      number = "+498938169930";
    }
    {
      name = "jbok-transferor";
      username = "1126428e1";
      password = "Hk12W33sebeH";
      prefix = "jb1";
      # number = "+498938169930";
    }
    {
      name = "jbok-counterpart";
      username = "1126428e7";
      password = "aP2ogBdy6Yyj";
      prefix = "jb2";
      number = "54";
    }
  ];

  # Contacts not backed by one of our own profiles.
  extraContacts = [
    {
      name = "(devneo) Channel 1";
      numbers = [ "+4951136059294" ];
    }
    {
      name = "(devneo) Channel 2";
      numbers = [ "+4951136059290" ];
    }
    {
      name = "(devneo) Channel 3";
      numbers = [ "+4951136059296" ];
    }
    {
      name = "(live) User 1";
      numbers = [ "+4920387835520" ];
    }
    {
      name = "Handy";
      numbers = [ "+4915755357012" ];
    }
  ];

  profileContacts = map (p: {
    inherit (p) name;
    numbers = [ p.number ];
  }) (builtins.filter (p: p ? number) (devProfiles ++ liveProfiles));

  mkLiveProfile =
    {
      name,
      username,
      password,
      prefix,
      domain ? "sip.sipgate.de",
      outbound ? "sip:${domain};transport=tls",
      transport ? "tls",
      mediaEnc ? "srtp-mand",
    }:
    {
      displayName = name;
      inherit
        username
        password
        domain
        outbound
        transport
        mediaEnc
        ;
      notify = false;
      mwi = true;
      customHeaders = [
        [
          "X-Client-Correlation-ID"
          "${prefix}-\${uuid}"
        ]
      ];
    };

  liveProfiles = [
    {
      name = "(live neo) User 1";
      username = "3821665e2";
      password = "KJ3RVAG7rTib";
      prefix = "rj-live-u1";
    }
    {
      name = "(live neo) Voiza 1";
      username = "3821665e3";
      password = "DjCFmJxR8JNT";
      prefix = "rj-live-v1";
      number = "+4920387835525";
    }
  ];

  # Trunks differ from accounts: registrar sipconnect.sipgate.de, UDP + plain
  # RTP only (no TCP/TLS for trunking yet), dev needs its own outbound proxy.
  mkTrunkProfile =
    {
      name,
      username,
      password,
      prefix,
      domain ? "sipconnect.sipgate.de",
      outbound ? null,
    }:
    {
      displayName = name;
      inherit
        username
        password
        domain
        outbound
        ;
      transport = "udp";
      mediaEnc = null;
      notify = false;
      mwi = true;
      customHeaders = [
        [
          "X-Client-Correlation-ID"
          "${prefix}-\${uuid}"
        ]
      ];
    };

  trunkProfiles = [
    {
      name = "(devneo) Trunk";
      username = "1126226t0";
      password = "oPq4SiKuSnzd";
      prefix = "rj-t";
      outbound = "sip:sipconnect.dev.sipgate.de";
    }
    {
      name = "(neo) Trunk";
      username = "3821665t0";
      password = "qbb4euUqRHdY";
      prefix = "rj-live-t";
    }
  ];

  profiles = builtins.listToAttrs (
    map (p: lib.nameValuePair p.name (mkDevProfile (removeAttrs p [ "number" ]))) devProfiles
    ++ map (p: lib.nameValuePair p.name (mkLiveProfile (removeAttrs p [ "number" ]))) liveProfiles
    ++ map (p: lib.nameValuePair p.name (mkTrunkProfile (removeAttrs p [ "number" ]))) trunkProfiles
  );
in
{
  imports = [
    ../shared.nix
    ../modules/ringo
  ];
  home.packages = with pkgs; [
    uutils-coreutils-noprefix
    # dockutil
  ];

  local = {
    ringo = {
      enable = true;
      contacts = profileContacts ++ extraContacts;
      inherit profiles;
      settings.contacts.resolve_incoming = false;
    };
  };
}
