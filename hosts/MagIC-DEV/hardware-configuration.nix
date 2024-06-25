{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [];

  # Kernel
  boot = {
    initrd.availableKernelModules = ["ata_piix" "vmw_pvscsi" "sd_mod" "sr_mod"];
    initrd.kernelModules = ["cifs"];
    kernelModules = [];
    extraModulePackages = [];
    kernel.sysctl = {
      "kernel.unprivileged_userns_clone" = 1; # for conda and mamba
    };
  };

  # Hardware
  modules.hardware = {
    # power management
    power = {
      enable = true;
      pm.enable = false;
      server.enable = true;
      cpuFreqGovernor = "performance";
    };
  };

  # CPU
  nix.settings = {
    cores = lib.mkDefault 8;
    max-jobs = lib.mkDefault 4;
  };

  # Display
  services.xserver.videoDrivers = ["vmware"];

  # Virtualisation
  virtualisation.vmware.guest.enable = true;

  services.logrotate.checkConfig = false;

  # Filesystem
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = ["noatime"];
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  };

  # Networking
  networking = {
    domain = "magic.local";
    nameservers = ["1.1.1.1" "8.8.8.8" "10.132.2.30" "10.132.2.31"];

    #networkmanager.enable = true;

    #networkmanager.enable = true;
    # Firewall
    ### https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/networking/firewall.nix
    ### Whether to enable the firewall.  This is a simple stateful
    ### firewall that blocks connection attempts to unauthorised TCP
    ### or UDP ports on this machine.
    # Docker and libvirt use iptables
    nftables.enable = false;
    firewall = {
      enable = true;
      allowPing = true;
      pingLimit = "--limit 1/minute --limit-burst 5";
      allowedTCPPorts = [22 80 443 3389 8080];
      allowedUDPPorts = [22 80 443 3389 8080];
    };

    # Network
    interfaces.ens192 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.132.2.152";
          prefixLength = 24;
        }
      ];
    };
    # DATA
    interfaces.ens224 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.222";
          prefixLength = 24;
        }
      ];
    };

    # Gateway
    defaultGateway = {
      address = "10.132.2.254";
      interface = "ens192";
    };
  };

  # Platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
