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
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

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
    initrd.kernelModules = [];
    kernelModules = [
      "tun"
      "vfio"
      "vfio_immmu_type1"
      "virtio"
      "vfio_pci"
      "kvm-amd"
      "acpi_call"
    ];

    kernelParams = [
      # didn't work
      #"usb.core.autosuspend=-1" # disable autosuspend
      #"usb.core.autosuspend=3600"  # 5 sencond # it seems no effect
    ];

    extraModulePackages = with config.boot.kernelPackages; [acpi_call];

    extraModprobeConfig = lib.mkMerge [
      "options kvm_amd nested=1"
      "options kvm_amd emulate_invalid_guest_state=0"
      "options kvm ignore_msrs=1"
      # idle audio card after one second
      #"options snd_hda_amd power_save=1"
      # enable wifi power saving (keep uapsd off to maintain low latencies)
      #"options iwlwifi power_save=1 uapsd_disable=1"
    ];
  };

  # Firmware
  services.fwupd.enable = true;

  # Hardware
  modules.hardware = {
    audio.enable = true;
    bluetooth.enable = true;
    fs = {
      enable = true;
      ssd.enable = true;
    };
    #sensors.enable = true;
    nvidia.enable = true;
    #https://discourse.nixos.org/t/usb-mouse-and-keyboard-poweroff-too-soon-udev/22459
    #mouse.enable = true;
    dualmonitor.enable = true;

    # power management
    power = {
      enable = true;
      pm.enable = true;
      pc.enable = true;
      cpuFreqGovernor = "performance";

      hibernate = false;
      #resumeDevice = "/dev/disk/by-uuid/e7e56401-3b27-4cb8-852b-9cc971f63512";
    };

    # network management
    #network = {
    #  enable = true;
    #  networkd.enable = true;
    #  MACAddress = "10:7b:44:8e:fe:b4";
    #  IPAddress = ["192.168.1.2/24"];
    #  RouteGateway = ["192.168.1.1"];
    #  DomainNameServer = ["223.5.5.5" "8.8.8.8" "119.29.29.29"];
    #  NetworkTimeServer = ["ntp7.aliyun.com" "ntp.aliyun.com"];
    #};
    network = {
      enable = true;
      networkd.enable = true;
      wireless.enable = false;
      #wireless.interfaces = ["wlp0s20f0u13"]; # wlp0s20f0u13
    };
  };
  networking.interfaces.enp5s0.useDHCP = true;

  #services.udev.extraRules = ''
  #  # keyboard autosuspand
  #  ##ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="0209", ATTR{power/autosuspend}="-1"
  #  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="0209", ATTR{power/control}="on"
  #  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="0209", ATTR{power/autosuspend_delay_ms}="3600000"

  #  # mouse autosuspand
  #  ##ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="005e", ATTR{power/autosuspend}="-1"
  #  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="005e", ATTR{power/control}="on"
  #  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="005e", ATTR{power/autosuspend_delay_ms}="3600000"
  #'';

  # CPU
  nix.settings = {
    cores = lib.mkDefault 12;
    max-jobs = lib.mkDefault 8;
  };
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Displays
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    xkb.layout = "us";
    serverFlagsSection = ''
      Option "StandbyTime" "20"
      Option "SuspendTime" "30"
      Option "OffTime" "45"
      Option "BlankTime" "45"
    '';
  };

  ## Single monitor
  ## https://github.com/NixOS/nixpkgs/issues/30796
  #services.xserver.displayManager.setupCommands = ''
  #  ${pkgs.xorg.xrandr}/bin/xrandr --dpi 168 --output HDMI-0 --mode 3840x2160 --rate 60 --pos 0x0 --primary
  #'';
  services.xserver.displayManager.setupCommands = ''
    LEFT='HDMI-A-2'
    RIGHT='HDMI-A-1'
    ${pkgs.xorg.xrandr}/bin/xrandr --dpi 168 --output $LEFT --mode 3840x2160 --rate 60 --pos 0x0 --scale 1x1 --primary --output $RIGHT --mode 3840x2160 --rate 60 --pos 3840x0 --scale 1x1 --right-of $LEFT
  '';

  # Mouse
  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
  };

  # Filesystem
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = ["noatime" "errors=remount-ro"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/home";
    fsType = "ext4";
    options = ["noatime"];
  };

  fileSystems."/mnt/store" = {
    device = "/dev/disk/by-label/store";
    fsType = "ext4";
  };

  swapDevices = [];

  # User
  user.extraGroups = ["tss" "video"];

  # Platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
