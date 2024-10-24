# https://linux-hardware.org/?probe=c38e664bd9
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Kernel
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "vfio-pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "sr_mod"
    ];
    initrd.kernelModules = ["i915"];
    kernelModules = [
      "tun"
      "vfio"
      "vfio_immmu_type1"
      "virtio"
      "vfio_pci"
      "kvm-intel"
      "acpi_call"
    ];

    supportedFilesystems = lib.mkForce ["ntfs" "cifs"];

    kernelParams = [
      # didn't work
      #"usb.core.autosuspend=-1" # disable autosuspend
      #"usb.core.autosuspend=3600"  # 5 sencond # it seems no effect
    ];

    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';

    extraModulePackages = with config.boot.kernelPackages; [acpi_call];
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
  environment.variables.VDPAU_DRIVER = "va_gl";

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

    # power management
    power = {
      enable = true;
      pm.enable = true;
      pc.enable = true;
      cpuFreqGovernor = "performance";
      hibernate.enable = true;
      resumeDevice = "/dev/disk/by-uuid/29706bb2-5983-4597-a450-4b4c370c8023";
    };

    # network management
    #network = {
    #  enable = true;
    #  networkd.enable = true;
    #  MACAddress = "a4:bb:6d:e2:d3:c8";
    #  IPAddress = ["10.132.22.122/24"];
    #  RouteGateway = ["10.132.22.254"];
    #  DomainNameServer = ["10.132.2.30" "10.132.2.31" "8.8.8.8" "223.5.5.5"];
    #  NetworkTimeServer = ["ntp7.aliyun.com" "ntp.aliyun.com"];
    #};

    #network = {
    #  enable = true;
    #  networkd.enable = true;
    #  wireless.enable = true;
    #  wireless.interfaces = ["wlan"];    # wlp0s20f0u13
    #  eLink.enable = true;
    #  wLink.enable = true;
    #  eMACAddress = "a4:bb:6d:e2:d3:c8"; # elan, wired
    #  wMACAddress = "f0:09:0d:1d:8a:4a"; # wlan, wireless
    #};

    network = {
      enable = true;
      networkd.enable = true;
      wireless.enable = true;
      wireless.interfaces = ["wlp0s20f0u13"]; # wlp0s20f0u13
    };
  };

  #networking.interfaces.elan.useDHCP = true; # needed when use networkd and wired
  #networking.interfaces.wlan.useDHCP = true; # needed when use networkmanager and wireless

  services.udev.extraRules = ''
    # USB power management
    ## https://www.kernel.org/doc/Documentation/usb/power-management.txt
    # USB devices
    ## $ lsusb
    ## $ ll /sys/bus/usb/devices/
    ### Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    ### Bus 001 Device 002: ID 0bda:8771 Realtek Semiconductor Corp. Bluetooth Radio
    ### Bus 001 Device 003: ID 046d:c542 Logitech, Inc. M185 compact wireless mouse
    ### Bus 001 Device 004: ID 046d:085c Logitech, Inc. C922 Pro Stream Webcam
    ### Bus 001 Device 007: ID 0c45:7692 Microdia USB Keyboard
    ### Bus 001 Device 011: ID 2357:012e TP-Link 802.11ac NIC
    ### Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    ### Bus 002 Device 007: ID 0bc2:ab24 Seagate RSS LLC Backup Plus Portable Drive

    # USB WIFI adapter autosuspand disabled
    ## TP-Link 802.11ac NIC
    ## $ grep 012e /sys/bus/usb/devices/*/idProduct
    ### /sys/bus/usb/devices/1-13/idProduct:012e
    ## cat /sys/bus/usb/devices/1-13/power/autosuspend
    ### 2
    ## cat /sys/bus/usb/devices/1-13/idProduct
    ### 012e
    ## cat /sys/bus/usb/devices/1-13/idVendor
    ### 2357
    ## driver
    ### /sys/bus/usb/devices/1-13/1-13:1.0/driver/module/drivers/usb:rtw_8822bu

    ## Bluetooth
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8771", ATTR{power/autosuspend}="-1"
    ## Mouse
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c542", ATTR{power/autosuspend}="-1"
    ## Webcam
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="085c", ATTR{power/autosuspend}="-1"
    ## Keyboard
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0c45", ATTR{idProduct}=="7692", ATTR{power/autosuspend}="-1"
    ## WIFI
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="2357", ATTR{idProduct}=="012e", ATTR{power/autosuspend}="-1"
  '';

  # CPU
  nix.settings = {
    cores = lib.mkDefault 12;
    max-jobs = lib.mkDefault 8;
  };
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Displays
  services.xserver = {
    enable = true;
    videoDrivers = ["intel"];
    exportConfiguration = true;
    xkb.layout = "us";
    serverFlagsSection = ''
      Option "StandbyTime" "20"
      Option "SuspendTime" "30"
      Option "OffTime" "45"
      Option "BlankTime" "45"
    '';
  };

  ## dual monitor
  ## https://github.com/NixOS/nixpkgs/issues/30796
  ##${pkgs.xorg.xrandr}/bin/xrandr --dpi 168 --output $RIGHT --mode 2560x1440 --rate 60 --pos 3840x0 --scale 1.2x1.2 --rotate inverted --rotate left --output $LEFT --mode 3840x2160 --rate 60 --pos 0x0 --scale 1x1 --primary
  services.xserver.displayManager.setupCommands = ''
    LEFT='DP1'
    RIGHT='DP2'
    ${pkgs.xorg.xrandr}/bin/xrandr --dpi 168 --output $LEFT --mode 3840x2160 --rate 60 --pos 0x0 --scale 1x1 --primary --output $RIGHT --mode 2560x1440 --rate 60 --pos 3840x0 --scale 1.24x1.24 --right-of $LEFT
  '';

  # Mouse
  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
  };

  # File System
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b664f175-f1be-4e65-b5aa-81a2244136c7";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DAC5-D30F";
    fsType = "vfat";
  };

  fileSystems."/mnt/store" = {
    device = "/dev/disk/by-uuid/c793da04-3e1a-44d3-8057-bc124d52a36a";
    fsType = "ext4";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/29706bb2-5983-4597-a450-4b4c370c8023";}
  ];

  # User
  user.extraGroups = ["tss" "video"]; # tss group has access to TPM devices

  # Platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
