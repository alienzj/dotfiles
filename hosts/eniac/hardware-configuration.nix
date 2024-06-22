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

    # power management
    power = {
      enable = true;
      pm.enable = true;
      pc.enable = true;
      cpuFreqGovernor = "performance";
      resumeDevice = "/dev/disk/by-uuid/e7e56401-3b27-4cb8-852b-9cc971f63512";
    };
  };

  services.udev.extraRules = ''
    # keyboard autosuspand
    ##ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="0209", ATTR{power/autosuspend}="-1"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="0209", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="0209", ATTR{power/autosuspend_delay_ms}="3600000"

    # mouse autosuspand
    ##ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="005e", ATTR{power/autosuspend}="-1"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="005e", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="005e", ATTR{power/autosuspend_delay_ms}="3600000"
  '';

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
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --dpi 168 --output HDMI-0 --mode 3840x2160 --rate 60 --pos 0x0 --primary
  '';

  # Mouse
  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
  };

  # Filesystem
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/952cf267-a657-4abb-b121-5bebf3a103aa";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C247-75AF";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/0dcf7734-5d12-4b60-8632-6a75196a31a7";
    fsType = "ext4";
  };

  fileSystems."/mnt/store" = {
    device = "/dev/disk/by-uuid/294a32c8-a7ab-4646-86c4-277dafc708b7";
    fsType = "ext4";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/e7e56401-3b27-4cb8-852b-9cc971f63512";}];

  # Network
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

  ## https://wiki.nixos.org/wiki/Systemd/networkd
  systemd.network = {
    ### whether to enable networkd or not
    enable = true;
    ### no need for ether network
    wait-online.enable = false;

    ## https://nixos.org/manual/nixos/stable/#sec-rename-ifs
    links."10-lan" = {
      enable = true;
      matchConfig.PermanentMACAddress = "10:7b:44:8e:fe:b4";
      linkConfig.Name = "lan";
    };

    networks."10-lan" = {
      enable = true;
      matchConfig.Name = "lan";
      matchConfig.Type = "ether";
      address = ["192.168.1.2/24"];
      gateway = ["192.168.1.1"];
      #dns = [
      #  # DNSpod
      #  "119.29.29.29"
      #  # aliyun DNS
      #  "223.5.5.5"
      #];
      ntp = ["ntp7.aliyun.com" "ntp.aliyun.com"];

      # make the routes on this interface a dependency for network-online.target
      linkConfig.RequiredForOnline = "routable";
    };
  };

  ## https://wiki.nixos.org/wiki/Systemd/resolved
  networking.nameservers = [
    "223.5.5.5"
    "8.8.8.8"
  ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = [
      "223.5.5.5"
      "8.8.8.8"
    ];
    dnsovertls = "true";
  };

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

  #system.activationScripts = {
  #  rfkillUnblockBluetooth = {
  #    text = ''
  #    rfkill unblock bluetooth
  #    '';
  #    deps = [];
  #  };
  #};

  # User
  user.extraGroups = ["tss" "video"];

  # Platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
