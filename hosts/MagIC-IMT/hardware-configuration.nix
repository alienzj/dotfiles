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
    cores = lib.mkDefault 12;
    max-jobs = lib.mkDefault 8;
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
    "/srv" = {
      device = "/dev/disk/by-label/DATA";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  # Networking
  networking = {
    domain = "magic.local";
    nameservers = ["1.1.1.1" "8.8.8.8" "10.132.2.30" "10.132.2.31"];

    #networkmanager.enable = true;

    firewall.enable = true;

    # Network
    interfaces.ens192 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.132.2.71";
          prefixLength = 24;
        }
      ];
    };
    # DATA
    interfaces.ens224 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.212";
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
