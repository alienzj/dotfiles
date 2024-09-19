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
    initrd.kernelModules = ["cifs" "nfs"];
    initrd.supportedFilesystems = ["nfs"];
    kernelModules = [];
    extraModulePackages = [];
    kernel.sysctl = {
      "kernel.unprivileged_userns_clone" = 1; # for conda and mamba
    };
  };

  # Hardware
  modules.hardware = {
    fs.enable = true;

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
    "/mnt/nfs1_external" = {
      device = "192.168.1.170:/export/nfs1_external";
      fsType = "nfs";
    };
    "/mnt/nfs2_external" = {
      device = "192.168.1.171:/export/nfs2_external";
      fsType = "nfs";
    };
    "/mnt/magic_archive_read" = {
      device = "//10.132.2.98/magic_archive_read";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,file_mode=0664,dir_mode=0775,vers=3.0,soft,rsize=8192,wsize=8192,mfsymlinks";
      in ["${automount_opts},credentials=/etc/nixos/smb-secrets-ResearchNAS,uid=2000,gid=3000"];
    };
    "/mnt/magic_archive_bcl" = {
      device = "//10.132.2.98/magic_archive_bcl";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,file_mode=0664,dir_mode=0775,vers=3.0,soft,rsize=8192,wsize=8192,mfsymlinks";
      in ["${automount_opts},credentials=/etc/nixos/smb-secrets-ResearchNAS,uid=2000,gid=3000"];
    };
    "/mnt/magic_archive_report" = {
      device = "//10.132.2.98/magic_archive_report";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,file_mode=0664,dir_mode=0775,vers=3.0,soft,rsize=8192,wsize=8192,mfsymlinks";
      in ["${automount_opts},credentials=/etc/nixos/smb-secrets-ResearchNAS,uid=2000,gid=3000"];
    };
    "/mnt/microbio_research" = {
      device = "//10.132.22.92/microbio_research";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,file_mode=0664,dir_mode=0775,vers=3.0,soft,rsize=8192,wsize=8192,mfsymlinks";
      in ["${automount_opts},credentials=/etc/nixos/smb-secrets-MicrobioResearch,uid=2000,gid=100"];
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
