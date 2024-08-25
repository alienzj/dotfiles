# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
      "kvm-intel"
      "tun"
      "virtio"
      "acpi_call"
  ];
  boot.kernelParams = [
      "mem_sleep_default=deep"
      "pcie_aspm.policy=powersupersave"
      "nmi_watchdog=0"
      "laptop_mode=5"
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [acpi_call];

  boot.extraModprobeConfig = lib.mkMerge [
      # idle audio card after one second
      "options snd_hda_intel power_save=1"
      # enable wifi power saving (keep uapsd off to maintain low latencies)
      "options iwlwifi power_save=1 uapsd_disable=1 11n_disable=1 wd_disable=1"

      # VM
      "options kvm_intel nested=1"
      "options kvm_intel emulate_invalid_guest_state=0"
      "options kvm ignore_msrs=1"
  ];

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
    #mouse.enable = true;

    # power management
    power = {
      enable = true;
      pm.enable = true;
      laptop.enable = true;
      #laptop.lightUpKey = 63;
      #laptop.lightDownKey = 64;
      cpuFreqGovernor = "ondemand";
      resumeDevice = "/dev/disk/by-uuid/f4b0dca0-b881-463e-acdf-544ad04cd4fa";
    };

    # network management
    #network = {
      #enable = true;
      #wireless.enable = true;
      #networkmanager.enable = true;
      #MACAddress = "7a:ad:a7:08:d3:7d"; 
      #DomainNameServer = ["223.5.5.5" "8.8.8.8"];
    #};
  };

  # CPU
  nix.settings = {
    cores = lib.mkDefault 12;
    max-jobs = lib.mkDefault 8;
  };

  # Displays
  services.xserver = {
    enable = true;
    #videoDrivers = ["amdgpu"];
    dpi = 120; # enable hidpi module
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


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b03ccbb5-e533-4797-9652-4e3fd4eaffaa";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2FDB-FB34";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/f4b0dca0-b881-463e-acdf-544ad04cd4fa"; }
    ];

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

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s13f0u1u3.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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

  system.activationScripts = {
    rfkillUnblockWlan = {
      text = ''
        rfkill unblock wlan
      '';
      deps = [];
    };
  };
  networking = {
    interfaces.wlp0s20f3.useDHCP = true;
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-fortisslvpn
        networkmanager-iodine
        networkmanager-l2tp
        networkmanager-openconnect
        networkmanager-openvpn
        networkmanager-vpnc
        networkmanager-sstp
      ];
    };
    nameservers = ["223.5.5.5" "8.8.8.8"];
  };
  networking.bridges.vmbr0.interfaces = [ "wlp0s20f3" ];
  networking.interfaces.vmbr0.useDHCP = lib.mkDefault true;

}
