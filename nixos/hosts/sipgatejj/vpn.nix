{ pkgs, ... }:
{
  environment.etc."NetworkManager/VPN/telearbeit-ca.pem".source = ./telearbeit-ca.pem;

  networking.networkmanager = {
    plugins = [ pkgs.networkmanager-openvpn ];

    ensureProfiles = {
      # password  in /etc/NetworkManager/vpn.env (root-only): VPN_PASSWORD=...
      environmentFiles = [ "/etc/NetworkManager/vpn.env" ];
      profiles.telearbeit = {
        connection = {
          id = "telearbeit";
          type = "vpn";
          uuid = "cc510ddb-684f-414c-8b44-418f2027ac0c";
          # NM does not implement autoconnect for VPN profiles (nm-settings(5)),
          # sudo nmcli connection modify "$w" connection.secondaries cc510ddb-684f-414c-8b44-418f2027ac0c instead
        };
        vpn = {
          service-type = "org.freedesktop.NetworkManager.openvpn";
          connection-type = "password";
          username = "hellermann";
          # udp6: force transport over IPv6; the IPv4 path is DS-Lite (PMTU 1460)
          remote = "ssl-vpn01.live.sipgate.net:453:udp6, ssl-vpn02.live.sipgate.net:453:udp6";
          remote-random = "yes";
          port = "453";
          dev = "tun";
          # outer path to the vpn endpoints is 1460 (DS-Lite); default 1500 drops full-size packets (EMSGSIZE)
          tunnel-mtu = "1380";
          # max wait per remote for the first handshake reply (NM default would be 30s)
          connect-timeout = "10";
          ca = "/etc/NetworkManager/VPN/telearbeit-ca.pem";
        };
        vpn-secrets = {
          password = "$VPN_PASSWORD";
        };
        # split tunnel
        ipv4 = {
          method = "auto";
          never-default = true;
        };
        ipv6 = {
          method = "auto";
          never-default = true;
        };
      };
    };
  };
}
