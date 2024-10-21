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
      "nvme"
      "xhci_pci"
      "usb_storage"
      "sd_mod"
    ];

    # "loading `amdgpu` kernelModule at stage 1.
    initrd.kernelModules = ["amdgpu"];

    kernelModules = [
      "kvm-amd"
      "tun"
      "virtio"
      "acpi_call"
    ];

    ## energy savings
    kernelParams = [
      "mem_sleep_default=deep"
      "pcie_aspm.policy=powersupersave"
      "nmi_watchdog=0"
      "laptop_mode=5"
      "amd_pstate=active"
    ];

    extraModulePackages = with config.boot.kernelPackages; [acpi_call];

    extraModprobeConfig = lib.mkMerge [
      # idle audio card after one second
      "options snd_hda_amd power_save=1"
      # enable wifi power saving (keep uapsd off to maintain low latencies)
      "options iwlwifi power_save=1 uapsd_disable=1 11n_disable=1 wd_disable=1"

      # VM
      "options kvm_amd nested=1"
      "options kvm_amd emulate_invalid_guest_state=0"
      "options kvm ignore_msrs=1"
    ];

    blacklistedKernelModules = ["nouveau"];
  };

  # Firmware
  services.fwupd.enable = true;

  # Hardware
  # GPU
  # https://github.com/NixOS/nixos-hardware/blob/master/common/gpu/amd/default.nix
  hardware.opengl = {
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      # opencl
      rocmPackages.clr.icd
      rocmPackages.clr
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };
  environment.variables.AMD_VULKAN_ICD = lib.mkDefault "RADV";

  # Hardware
  modules.hardware = {
    audio.enable = true;
    bluetooth.enable = true;
    fs = {
      enable = true;
      ssd.enable = true;
    };
    #sensors.enable = true;
    #mouse.enable = true;

    # power management
    power = {
      enable = true;
      pm.enable = true;
      laptop.enable = true;
      laptop.lightUpKey = 63;
      laptop.lightDownKey = 64;
      cpuFreqGovernor = "ondemand";
      hibernate.enable = true;
      resumeDevice = "/dev/disk/by-uuid/bfc2ce50-8fd6-4aa8-9c8f-375dbed9e357";
    };

    # network management
    #network = {
    #  enable = true;
    #  wireless.enable = true;
    #  networkmanager.enable = true;
    #  MACAddress = "3c:9c:0f:17:58:95";
    #  DomainNameServer = ["223.5.5.5" "8.8.8.8"];
    #};

    network = {
      enable = true;
      networkd.enable = true;
      wireless.enable = true;
      wireless.interfaces = ["wlp1s0"];
    };
  };

  # CPU
  nix.settings = {
    cores = lib.mkDefault 12;
    max-jobs = lib.mkDefault 8;
  };
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Displays
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
    #dpi = 168; # enable hidpi module
    exportConfiguration = true;
    xkb.layout = "us";
    serverFlagsSection = ''
      Option "StandbyTime" "20"
      Option "SuspendTime" "30"
      Option "OffTime" "45"
      Option "BlankTime" "45"
    '';
  };

  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      clickMethod = "clickfinger";
      naturalScrolling = true;
    };
  };

  # Filesystem
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f53e0fc6-5d76-4106-a106-558af7be7d16";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6018-D534";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/bfc2ce50-8fd6-4aa8-9c8f-375dbed9e357";
    }
  ];

  # https://github.com/NixOS/nixpkgs/issues/23912
  #fileSystems."/tmp" = {
  #  device = "tmpfs";
  #  fsType = "tmpfs";
  #  options = ["noatime" "nodev" "size=12G"];
  #};

  # TODO
  # FIXME
  # Increase size of /run/user/1000 to 80% of RAM
  #services.logind.extraConfig = ''
  #  RuntimeDirectorySize=12G
  #'';
  boot.tmp.tmpfsSize = "80%"; # avoid no space left when rebuild

  # User
  # https://nixos.wiki/wiki/TPM
  #security.tpm2.enable = true;
  #security.tpm2.pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  #security.tpm2.tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  user.extraGroups = ["tss" "video"]; # tss group has access to TPM devices

  # Platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
