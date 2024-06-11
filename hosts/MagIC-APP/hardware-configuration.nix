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
    "/backup" = {
      device = "/dev/disk/by-label/backup";
      fsType = "noatime";
    };
  };

  swapDevices = [{device = "/dev/disk/by-label/swap";}];

  # Networking
  networking = {
    domain = "magic.local";
    nameservers = ["1.1.1.1" "8.8.8.8" "10.132.2.30" "10.132.2.31"];

    #networkmanager.enable = true;

    firewall.enable = true;
    firewall.allowedTCPPorts = [8000 8888];

    # Network
    interfaces.ens192 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.132.2.151";
          prefixLength = 24;
        }
      ];
    };
    # DATA
    interfaces.ens224 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.221";
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
