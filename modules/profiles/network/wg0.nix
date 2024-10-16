# modules/profiles/network/wg0 -- homelab VPN
{
  hey,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib;
  mkIf (elem "wg0" config.modules.profiles.networks) (mkMerge [
    {
      networking.firewall.allowedUDPPorts = [51820];

      age.secrets.wg0PrivateKey.owner = "systemd-network";

      systemd.network = {
        enable = true;
        netdevs."90-wg0" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg0";
          };
          wireguardConfig = {
            PrivateKeyFile = config.age.secrets.wg0PrivateKey.path;
            ListenPort = "51820";
          };
          wireguardPeers = [
            {
              wireguardPeerConfig = {
                PublicKey = "kuv6kPygJbjcAbhogEst5m8XyKz9pn0XgyR7EcnveAU=";
                AllowedIPs = ["10.0.0.0/24"];
                Endpoint = "0.home.alienzj.tech:51820";
              };
            }
          ];
        };
        networks.wg0 = {
          # address = ...;
          matchConfig.Name = "wg0";
          DHCP = "no";
          dns = ["10.0.0.1"];
          ntp = ["10.0.0.1"];
          domains = ["home.alienzj.tech"];
          networkConfig = {
            DNSSEC = false;
            DNSDefaultRoute = false;
          };
          routes = [
            {
              routeConfig = {
                Gateway = "10.0.0.1";
                GatewayOnLink = true;
                Destination = "10.0.0.0/24";
              };
            }
          ];
        };
      };

      systemd.network.wait-online.ignoredInterfaces = ["wg0"];
      boot.initrd.systemd.network.wait-online.ignoredInterfaces = ["wg0"];
    }

    # ...
  ])
