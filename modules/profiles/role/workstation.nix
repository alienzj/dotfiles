# profiles/role/workstation.nix
#
# TODO
{
  hey,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib;
  mkIf (config.modules.profiles.role == "workstation") (mkMerge [
    {
      boot = {
        # HACK I used to disable mitigations for spectre, meltdown, L1TF,
        #   retbleed, and other CPU vulnerabilities for a marginal performance
        #   gain on non-servers, but it really makes little to no difference on
        #   modern CPUs. It may still be worth it on older Xeons and the like (on
        #   workstations) though. I've preserved this in comments for future
        #   reference.
        #
        #   DO NOT COPY AND UNCOMMENT IT BLINDLY! If you're looking for
        #   optimizations, these aren't the droids you're looking for!
        # kernelParams = [ "mitigations=off" ];

        loader = {
          # I'm not a big fan of Grub, so if it's not in use...
          systemd-boot.enable = mkDefault true;
          # For much quicker boot up to NixOS. I can use `systemctl reboot
          # --boot-loader-entry=X` instead.
          timeout = mkDefault 24;
        };

        # For a truly silent boot!
        # kernelParams = [
        #   "quiet"
        #   "splash"
        #   "udev.log_level=3"
        # ];
        # consoleLogLevel = 0;
        # initrd.verbose = false;

        # Common kernels across workstations
        initrd.availableKernelModules = [
          "xhci_pci" # USB 3.0
          "usb_storage" # USB mass storage devices
          "usbhid" # USB human interface devices
          "ahci" # SATA devices on modern AHCI controllers
          "sd_mod" # SCSI, SATA, and IDE devices
        ];

        # The default maximum is too low, which starves IO hungry apps.
        kernel.sysctl."fs.inotify.max_user_watches" = 524288;
      };

      # TODO ...
      powerManagement.cpuFreqGovernor = mkDefault "performance";

      # Use systemd-{network,resolve}d; a more unified networking backend that's
      # easier to reconfigure downstream, especially where split-DNS setups (e.g.
      # VPNs) are concerned.
      networking = {
        useDHCP = false;
        useNetworkd = true;
      };
      systemd = {
        network = {
          # Automatically manage all wired/wireless interfaces.
          networks = {
            "30-wired" = {
              enable = true;
              name = "en*";
              networkConfig.DHCP = "yes";
              networkConfig.IPv6PrivacyExtensions = "kernel";
              linkConfig.RequiredForOnline = "no"; # don't hang at boot (if dc'ed)
              dhcpV4Config.RouteMetric = 1024;
            };
            "30-wireless" = {
              enable = true;
              name = "wl*";
              networkConfig.DHCP = "yes";
              networkConfig.IPv6PrivacyExtensions = "kernel";
              linkConfig.RequiredForOnline = "no"; # don't hang at boot (if dc'ed)
              dhcpV4Config.RouteMetric = 2048; # prefer wired
            };
          };

          # systemd-networkd-wait-online waits forever for *all* interfaces to be
          # online before passing; which is unlikely to ever happen.
          wait-online = {
            anyInterface = true;
            timeout = 30;

            # The anyInterface setting is still finnicky for some networks, so I
            # simply turn off the whole check altogether.
            enable = false;
          };
        };
      };
      boot.initrd.systemd.network.wait-online = {
        anyInterface = true;
        timeout = 10;
      };

      modules.xdg.ssh.enable = true;

      # See systemd/systemd#10579
      services.resolved.dnssec = "false";
    }

    (mkIf config.modules.services.ssh.enable {
      programs.ssh.startAgent = true;
      services.openssh.startWhenNeeded = true;
    })

    # ...
  ])
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
#  {
#    hey,
#    lib,
#    options,
#    config,
#    pkgs,
#    ...
#  }:
#    with lib;
#    with hey.lib; let
#      cfg = config.modules.hardware.network;
#    in {
#      options.modules.hardware.network = with types; {
#        enable = mkBoolOpt false;
#        networkd.enable = mkBoolOpt false;
#        networkmanager.enable = mkBoolOpt false;
#        wireless.enable = mkBoolOpt false;
#        MACAddress = mkOpt types.str "10:7b:44:8e:fe:b4";
#        IPAddress = mkOption {
#          type = with types; listOf types.str;
#          default = [""];
#        };
#        RouteGateway = mkOption {
#          type = with types; listOf types.str;
#          default = [""];
#        };
#        DomainNameServer = mkOption {
#          type = with types; listOf types.str;
#          default = ["223.5.5.5" "8.8.8.8" "119.29.29.29"];
#        };
#        NetworkTimeServer = mkOption {
#          type = with types; listOf types.str;
#          default = ["ntp7.aliyun.com" "ntp.aliyun.com"];
#        };
#      };
#
#      config = mkIf cfg.enable (mkMerge [
#        {
#          # Firewall
#          ### https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/networking/firewall.nix
#          ### Whether to enable the firewall.  This is a simple stateful
#          ### firewall that blocks connection attempts to unauthorised TCP
#          ### or UDP ports on this machine.
#          networking = {
#            # Docker and libvirt use iptables
#            nftables.enable = false;
#            firewall = {
#              enable = true;
#              allowPing = true;
#              pingLimit = "--limit 1/minute --limit-burst 5";
#              allowedTCPPorts = [22 80 443 3389 8080];
#              allowedUDPPorts = [22 80 443 3389 8080];
#            };
#          };
#
#          # rename interface
#          systemd.network = {
#            ## https://nixos.org/manual/nixos/stable/#sec-rename-ifs
#            links."10-lan" = {
#              enable = true;
#              matchConfig.PermanentMACAddress = cfg.MACAddress;
#              linkConfig.Name = "lan";
#            };
#          };
#        }
#
#        # used in ether network
#        (mkIf cfg.networkd.enable {
#          systemd.network = {
#            ### whether to enable networkd or not
#            enable = true;
#            ### no need for ether network
#            wait-online.enable = false;
#
#            networks."10-lan" = {
#              enable = true;
#              matchConfig.Name = "lan";
#              matchConfig.Type = "ether";
#              address = cfg.IPAddress;
#              gateway = cfg.RouteGateway;
#              dns = cfg.DomainNameServer;
#              ntp = cfg.NetworkTimeServer;
#
#              # make the routes on this interface a dependency for network-online.target
#              linkConfig.RequiredForOnline = "routable";
#
#              networkConfig = {
#                Bridge = "vmbr0";
#              };
#            };
#
#            netdevs."vmbr0" = {
#              netdevConfig = {
#                Name = "vmbr0";
#                Kind = "bridge";
#              };
#            };
#
#            networks."10-lan-bridge" = {
#              matchConfig.Name = "vmbr0";
#              networkConfig = {
#                IPv6AcceptRA = true;
#                DHCP = "ipv4";
#              };
#              linkConfig.RequiredForOnline = "routable";
#            };
#          };
#        })
#
#        # used in wlan network
#        (mkIf cfg.wireless.enable {
#          system.activationScripts = {
#            rfkillUnblockWlan = {
#              text = ''
#                rfkill unblock wlan
#              '';
#              deps = [];
#            };
#          };
#        })
#
#        # used in wlan network
#        (mkIf cfg.networkmanager.enable {
#          networking = {
#            interfaces.lan.useDHCP = true;
#            networkmanager = {
#              enable = true;
#              plugins = with pkgs; [
#                networkmanager-fortisslvpn
#                networkmanager-iodine
#                networkmanager-l2tp
#                networkmanager-openconnect
#                networkmanager-openvpn
#                networkmanager-vpnc
#                networkmanager-sstp
#              ];
#            };
#            nameservers = cfg.DomainNameServer;
#          };
#        })
#      ]);
#    }

