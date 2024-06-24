# reference
## networking.useNetworkd
### https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/tasks/network-interfaces.nix
### Whether we should use networkd as the network configuration backend or
### the legacy script based system. Note that this option is experimental,
### enable at your own risk.
## networking.networkmanager.enable ??
### https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/networking/networkmanager.nix
### Whether to use NetworkManager to obtain an IP address and other
### configuration for all network interfaces that are not manually
### configured. If enabled, a group `networkmanager`
### will be created. Add all users that should have permission
### to change network settings to this group.
## systemd-networkd
### https://wiki.nixos.org/wiki/Systemd/networkd
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.network;
in {
  options.modules.hardware.network = with types; {
    enable = mkBoolOpt false;
    networkd.enable = mkBoolOpt false;
    networkmanager.enable = mkBoolOpt false;
    MACAddress = mkOpt types.str "10:7b:44:8e:fe:b4";
    IPAddress = mkOpt listOf types.str [""];
    RouteGateway = mkOpt listOf types.str [""];
    DomainNameServer = mkOpt listOf types.str ["223.5.5.5" "8.8.8.8" "119.29.29.29"];
    NTP = mkOpt listOf types.str ["ntp7.aliyun.com" "ntp.aliyun.com"];
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Firewall
      ### https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/networking/firewall.nix
      ### Whether to enable the firewall.  This is a simple stateful
      ### firewall that blocks connection attempts to unauthorised TCP
      ### or UDP ports on this machine.
      networking = {
        # Docker and libvirt use iptables
        nftables.enable = false;
        firewall = {
          enable = true;
          allowPing = true;
          pingLimit = "--limit 1/minute --limit-burst 5";
          allowedTCPPorts = [22 80 443 3389 8080];
          allowedUDPPorts = [22 80 443 3389 8080];
        };
      };
    }

    # used in ether network
    (mkIf cfg.networkd.enable {
      systemd.network = {
        ### whether to enable networkd or not
        enable = true;
        ### no need for ether network
        wait-online.enable = false;

        ## https://nixos.org/manual/nixos/stable/#sec-rename-ifs
        links."10-lan" = {
          enable = true;
          matchConfig.PermanentMACAddress = cfg.MACAddress;
          linkConfig.Name = "lan";
        };

        networks."10-lan" = {
          enable = true;
          matchConfig.Name = "lan";
          matchConfig.Type = "ether";
          address = cfg.IPAddress;
          gateway = cfg.RouteGateway;
          dns = cfg.DomainNameServer;
          ntp = NTP;

          # make the routes on this interface a dependency for network-online.target
          linkConfig.RequiredForOnline = "routable";
        };
      };
    })

    (mkIf cfg.networkmanager.enable {
      })
  ]);
}
