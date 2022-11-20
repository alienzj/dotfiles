# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "tun" "virtio" ];
  boot.extraModulePackages = [ ];

  modules.hardware = {
    audio.enable = true;
    bluetooth.enable = true;
    fs = {
      enable = true;
      ssd.enable = true;
    };
    #sensors.enable = true;
  };

  nix.settings.max-jobs = lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.intel.updateMicrocode = true;

  # Displays
  services.xserver = {
    enable = true;
    videoDrivers = [ "modesetting" ];
    #dpi = 168;
    exportConfiguration = true;
    layout = "us";
    #xkbOptions = "compose:caps";

    libinput = {
      enable = true;
      #touchpad = {
      #  tapping = true;
      #  clickMethod = "clickfinger";
      #	naturalScrolling = true;
      #};
    };
  };

  #console.font =
  #  "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  #environment.variables = {
  #  # QT_SCALE_FACTOR = "2";
  #  GDK_SCALE = "2";
  #  GDK_DPI_SCALE = "0.5";
  #  _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  #};


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

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  #powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  #hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}