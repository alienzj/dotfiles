# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Kernel
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "vfio-pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
    initrd.kernelModules = [ "i915" ];
    kernelModules = [ "tun" "vfio" "vfio_immmu_type1" "virtio" "vfio_pci" "kvm-intel"];
    extraModulePackages = [ ];
    supportedFilesystems = lib.mkForce [ "ntfs" "cifs" ];

    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';
  };

  # Firmware
  services.fwupd.enable = true;

  # NixOS Hardware options
  hardware.opengl = {
    enable = true; 
    extraPackages = with pkgs; [
      vaapiIntel
      libvdpau-va-gl
      intel-media-driver
    ];
  };
  environment.variables = {
    VDPAU_DRIVER = "va_gl";
  };
 
  # Custom hardware options
  modules.hardware = {
    audio.enable = true;
    bluetooth.enable = true;
    fs = {
      enable = true;
      ssd.enable = true;
    };
    mouse.enable = true;
    dualmonitor.enable = true; # dual monitor
  };

  # CPU
  nix.settings.max-jobs = lib.mkDefault 16;
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Displays
  services.xserver = {
    enable = true;
    videoDrivers = [ "intel" ];
    exportConfiguration = true;
    xkb.layout = "us";
    serverFlagsSection = ''
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
      Option "BlankTime" "0"
    '';
  };

  ## dual monitor
  ## https://github.com/NixOS/nixpkgs/issues/30796
  services.xserver.displayManager.setupCommands = ''
    LEFT='DP1'
    RIGHT='DP2'
    ${pkgs.xorg.xrandr}/bin/xrandr --dpi 168 --output $RIGHT --mode 2560x1440 --rate 60 --pos 3840x0 --scale 1.2x1.2 --rotate inverted --rotate left --output $LEFT --mode 3840x2160 --rate 60 --pos 0x0 --scale 1x1 --primary
  '';

  # Mouse
  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
  };
 
  # File System
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b664f175-f1be-4e65-b5aa-81a2244136c7";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/DAC5-D30F";
      fsType = "vfat";
    };

  fileSystems."/mnt/store" =
    { device = "/dev/disk/by-uuid/c793da04-3e1a-44d3-8057-bc124d52a36a";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/29706bb2-5983-4597-a450-4b4c370c8023"; }
    ];


  # Network
  #https://nixos.org/manual/nixos/stable/#sec-rename-ifs
  systemd.network.links."10-lan" = {
    matchConfig.PermanentMACAddress = "a4:bb:6d:e2:d3:c8";
    linkConfig.Name = "lan";
  };

  networking = {
    domain = "magic.local";
    nameservers = [ "1.1.1.1" "8.8.8.8" "10.132.2.30" "10.132.2.31" ];

    #networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 3389 8080 ];
      allowedUDPPorts = [ 22 80 443 3389 8080 ];
    };
 
    # Network
    interfaces.lan = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "10.132.22.122";
        prefixLength = 24;
      }];
    };
    # Gateway
    defaultGateway = {
      address = "10.132.22.254";
      interface = "lan";
    };
  };

  #system.activationScripts = {
  #  rfkillUnblockBluetooth = {
  #    text = ''
  #    rfkill unblock bluetooth
  #    '';
  #    deps = [];
  #  };
  #};

  # User
  # https://nixos.wiki/wiki/TPM
  #security.tpm2.enable = true;
  #security.tpm2.pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  #security.tpm2.tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  user.extraGroups = [ "tss" "video" ];  # tss group has access to TPM devices

  # Platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
