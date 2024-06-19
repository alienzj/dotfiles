# reference
## https://www.kernel.org/doc/html/latest/admin-guide/pm/
## https://wiki.archlinux.org/title/Category:Power_management
## https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate
## https://wiki.nixos.org/wiki/Power_Management
## https://github.com/huataihuang/cloud-atlas-draft/blob/master/os/linux/redhat/system_administration/systemd/hibernate_with_fedora_in_laptop.md
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.power;
in {
  options.modules.hardware.power = with types; {
    enable = mkBoolOpt false;
    isLaptop = mkBoolOpt false;
    lightUpKey = mkOpt types.int 63;
    lightDownKey = mkOpt types.int 64;
    isPC = mkBoolOpt false;
    isServer = mkBoolOpt false;
    cpuFreqGovernor = mkOpt types.str "ondemand"; # performance

    ## 设置Hibernate休眠模式关键点是设置足够存储笔记本内存内容的swap空间，否则会导致hibernate失败
    ## adjust swap size if you using LVM
    ## https://baldpenguin.blogspot.com/2016/03/enabling-hibernation-in-fedora-23.html
    ## https://github.com/huataihuang/cloud-atlas-draft/tree/master/os/linux/storage/device-mapper/lvm
    resumeDevice = mkOpt types.str "/dev/disk/by-label/swap";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        acpi
        # Powertop is a power analysis tool
        powertop
      ];

      powerManagement = {
        enable = true;
        cpuFreqGovernor = cfg.cpuFreqGovernor;
        powertop.enable = true;
      };
    }

    ## https://wiki.archlinux.org/title/Laptop_Mode_Tools
    ### Laptop Mode Tools is a laptop power saving package for Linux systems.
    ### It is the primary way to enable the Laptop Mode feature of the Linux kernel, which lets your hard drive spin down.
    ### In addition, it allows you to tweak a number of other power-related settings using a simple configuration file.
    ### Combined with acpid and CPU frequency scaling, LMT provides most users with a complete notebook power management suite.

    ## Nixos: https://wiki.nixos.org/wiki/Laptop
    ### A common tool used to save power on laptops is TLP, which has sensible defaults for most laptops.
    (mkIf cfg.isLaptop {
      services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 20;

          #Optional helps save long term battery health
          START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
          STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        };
      };

      ### Another tool used for power management is auto-cpufreq which aims to replace TLP.
      #services.auto-cpufreq = {
      #  enable = true;
      #  settings = {
      #    battery = {
      #      governor = "powersave";
      #      turbo = "never";
      #    };
      #    charger = {
      #      governor = "performance";
      #      turbo = "auto";
      #    };
      #  };
      #};

      ## screen brightness
      programs.light.enable = true;
      services.actkbd = {
        enable = true;
        bindings = [
          #{ keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
          #{ keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
          {
            keys = [cfg.lightUpKey];
            events = ["key"];
            command = "/run/current-system/sw/bin/light -U 10";
          }
          {
            keys = [cfg.lightDownKey];
            events = ["key"];
            command = "/run/current-system/sw/bin/light -A 10";
          }
        ];
      };
    })

    # TODO
    #(mkIf cfg.isPC {
    #  })

    # TODO
    #(mkIf cfg.isServer {
    #  })
  ]);
}
