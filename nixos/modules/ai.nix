{ config, lib, ... }:
{
  age.secrets.cliproxyapi-api-key.file = ../../secrets/cliproxyapi-api-key.age;

  services.cliproxyapi = {
    enable = true;
    settings = {
      # local pi clients only
      server.host = "127.0.0.1";
      access.api-keys = [ { _secret = config.age.secrets.cliproxyapi-api-key.path; } ];
    };
  };

  programs.fish.shellAliases.cliproxyapi = "sudo -u cliproxyapi -H ${lib.getExe config.services.cliproxyapi.package} -config /var/lib/cliproxyapi/config.yaml";
}
