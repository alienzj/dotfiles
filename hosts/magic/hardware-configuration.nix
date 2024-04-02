# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" "tun" "virtio" ];
  boot.extraModulePackages = [ ];
  #boot.supportedFilesystems = [ "ntfs" ];
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';

  hardware.opengl.enable = true; 
  environment.variables = {
    VDPAU_DRIVER = "va_gl";
  };

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    libvdpau-va-gl
    intel-media-driver
  ];

  services.fwupd.enable = true;

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

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
    powertop.enable = true;

  };
  services.thermald.enable = true;

  # Displays
  services.xserver = {
    enable = true;
    #videoDrivers = [ "modesetting" ];
    videoDrivers = [ "intel" ];
    dpi = 168;
    exportConfiguration = true;
    xkb.layout = "us";
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

  console.font =
    "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  # reference
  # https://wiki.archlinuxcn.org/zh-hans/HiDPI
  environment.variables = {
    # QT method: manually
    ##QT_SCALE_FACTOR = "2";
    QT_SCREEN_SCALE_FACTORS = "2;2";
    QT_AUTO_SCREEN_SCALE_FACTOR = "0";

    # QT method: automatically
    #QT_AUTO_SCREEN_SCALE_FACTOR = "1";

    # GTK
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };


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
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # https://nixos.wiki/wiki/TPM
  #security.tpm2.enable = true;
  #security.tpm2.pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  #security.tpm2.tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  users.users.alienzj.extraGroups = [ "tss" ];  # tss group has access to TPM devices
}
