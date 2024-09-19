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
    wireless.enable = mkBoolOpt false;
    wireless.interfaces = mkOption {
      type = with types; listOf types.str;
      default = ["wlan"];
    }; 
    #eLink.enable = mkBoolOpt false;
    #wLink.enable = mkBoolOpt false;
    #eMACAddress = mkOpt types.str "";
    #wMACAddress = mkOpt types.str "";
    #IPAddress = mkOption {
    #  type = with types; listOf types.str;
    #  default = [""];
    #};
    #RouteGateway = mkOption {
    #  type = with types; listOf types.str;
    #  default = [""];
    #};
    DomainNameServer = mkOption {
      type = with types; listOf types.str;
      default = ["223.5.5.5" "8.8.8.8" "119.29.29.29"];
    };
    #NetworkTimeServer = mkOption {
    #  type = with types; listOf types.str;
    #  default = ["ntp7.aliyun.com" "ntp.aliyun.com"];
    #};
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

      networking = {
        useDHCP = false;
        ### whether to enable networkd or not
	useNetworkd = true;
      };
      #networking.interfaces.elan.useDHCP = true; # needed when use networkd
      #networking.interfaces.wlan.useDHCP = true; # needed when use networkmanager

      systemd = {
        network = {
          # Automatically manage all wired/wireless interfaces.

	  #links."30-elan" = {
	  #  enable = cfg.eLink.enable;
	  #  matchConfig.PermanentMACAddress = cfg.eMACAddress;
	  #  linkConfig.Name = "elan";
	  #};
	  #links."30-wlan" = {
	  #  enable = cfg.wLink.enable;
	  #  matchConfig.PermanentMACAddress = cfg.wMACAddress;
	  #  linkConfig.Name = "wlan";
	  #};

	  networks = {
            "30-wired" = {
	      enable = true;
	      name = "en*";
	      #matchConfig.Name = "elan";
	      #matchConfig.Type = "ether";
	      networkConfig.DHCP = "yes";
              networkConfig.IPv6PrivacyExtensions = "kernel";
              linkConfig.RequiredForOnline = "no"; # don't hang at boot (if dc'ed)
              dhcpV4Config.RouteMetric = 1024;
	    };
	    "30-wireless" = {
              enable = true;
              name = "wl*";
	      #matchConfig.Name = "wlan";
	      #matchConfig.Type = "wireless";
              networkConfig.DHCP = "yes";
              networkConfig.IPv6PrivacyExtensions = "kernel";
              linkConfig.RequiredForOnline = "no"; # don't hang at boot (if dc'ed)
              dhcpV4Config.RouteMetric = 2048;     # prefer wired
            };
	  };

          wait-online = {
            anyInterface = true;
            timeout = 30;

            # The anyInterface setting is still finnicky for some networks, so I
            # simply turn off the whole check altogether.
            enable = false;
          };


          ### no need for ether network
          #wait-online.enable = false;

          #networks."10-lan" = {
          #  enable = true;
          #  matchConfig.Name = "lan";
          #  matchConfig.Type = "ether";
          #  address = cfg.IPAddress;
          #  gateway = cfg.RouteGateway;
          #  dns = cfg.DomainNameServer;
          #  ntp = cfg.NetworkTimeServer;

          #  # make the routes on this interface a dependency for network-online.target
          #  linkConfig.RequiredForOnline = "routable";

          #  networkConfig = {
          #    Bridge = "vmbr0";
          #  };
          #};

          #netdevs."vmbr0" = {
          #  netdevConfig = {
          #    Name = "vmbr0";
          #    Kind = "bridge";
          #  };
          #};

          #networks."10-lan-bridge" = {
          #  matchConfig.Name = "vmbr0";
          #  networkConfig = {
          #    IPv6AcceptRA = true;
          #    DHCP = "ipv4";
          #  };
          #  linkConfig.RequiredForOnline = "routable";
          #};
        };
      };

      boot.initrd.systemd.network.wait-online = {
        anyInterface = true;
        timeout = 10;
      };

      # See systemd/systemd#10579
      services.resolved.dnssec = "false";
    })


    # reference
    ## https://wiki.archlinux.org/title/Wpa_supplicant
    # used in wireless network
    ## example
    ### sudo cat /etc/wpa_supplicant.d/wlp0s20f0u13.conf
    ### ctrl_interface=DIR=/run/wpa_supplicant GROUP=users
    ### update_config=1
    ### p2p_disabled=1
    ### okc=1
    
    ### network={
    ###         ssid="INNO2"
    ###         psk="HkstpInno2"
    ###         mesh_fwding=1
    ### }
    (mkIf cfg.wireless.enable {
      environment.systemPackages = with pkgs; [
        wpa_supplicant  # for wpa_cli
      ];


      networking.wireless.interfaces = cfg.wireless.interfaces;
      networking.supplicant = listToAttrs (map
        (int: nameValuePair int {
          # Allow wpa_(cli|gui) to modify networks list
          userControlled = {
          enable = true;
          group = "users";
        };
        configFile = {
          path = "/etc/wpa_supplicant.d/${int}.conf";
          writable = true;
        };
        extraConf = ''
          ap_scan=1
          p2p_disabled=1
          okc=1
        '';
        })
        cfg.wireless.interfaces);

      systemd.tmpfiles.rules =
        [ "d /etc/wpa_supplicant.d 700 root root - -" ] ++
        (map (int: "f /etc/wpa_supplicant.d/${int}.conf 700 root root - -") cfg.wireless.interfaces);

      systemd.network.wait-online.ignoredInterfaces = cfg.wireless.interfaces;
      boot.initrd.systemd.network.wait-online.ignoredInterfaces = cfg.wireless.interfaces;

      #system.activationScripts = {
      #  rfkillUnblockWlan = {
      #    text = ''
      #      rfkill unblock wlan
      #    '';
      #    deps = [];
      #  };
      #};
    })

    # only be used in wireless network
    (mkIf cfg.networkmanager.enable {
      networking = {
        interfaces."{cfg.wireless.interfaces}".useDHCP = true;
        networkmanager = {
          enable = true;
          plugins = with pkgs; [
            networkmanager-fortisslvpn
            networkmanager-iodine
            networkmanager-l2tp
            networkmanager-openconnect
            networkmanager-openvpn
            networkmanager-vpnc
            networkmanager-sstp
          ];
        };
        nameservers = cfg.DomainNameServer;
      };
    })
  ]);
}
