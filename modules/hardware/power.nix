# reference
## https://www.kernel.org/doc/html/latest/admin-guide/pm/
## https://wiki.archlinux.org/title/Category:Power_management
## https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate
## https://wiki.archlinux.org/title/Power_management/Wakeup_triggers
## https://wiki.nixos.org/wiki/Power_Management
## https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/power-management.nix
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
    pm.enable = mkBoolOpt false;
    hibernate.enable = mkBoolOpt false;
    laptop.enable = mkBoolOpt false;
    laptop.lightUpKey = mkOpt types.int 63;
    laptop.lightDownKey = mkOpt types.int 64;
    pc.enable = mkBoolOpt false;
    server.enable = mkBoolOpt false;
    cpuFreqGovernor = mkOpt types.str "ondemand"; # performance

    ## 设置Hibernate休眠模式关键点是设置足够存储笔记本内存内容的swap空间，否则会导致hibernate失败
    ## adjust swap size if you using LVM
    ## https://baldpenguin.blogspot.com/2016/03/enabling-hibernation-in-fedora-23.html
    ## https://github.com/huataihuang/cloud-atlas-draft/tree/master/os/linux/storage/device-mapper/lvm
    #resumeDevice = mkOpt types.str "/dev/disk/by-label/swap";
    resumeDevice = mkOpt types.str "";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.pm.enable {
      environment.systemPackages = with pkgs; [
        acpi
        # Powertop is a power analysis tool
        ## https://wiki.archlinux.org/title/Powertop
        ## gerenate report
        ## powertop --html=powerreport.html
        powertop
      ];

      powerManagement = {
        enable = true;
        cpuFreqGovernor = cfg.cpuFreqGovernor;
        powertop.enable = true;

        ## TODO
        ## FIXME
        ## Commands executed after the system resumes from suspend-to-RAM.
        ##resumeCommands = "";
        ## Commands executed when the machine powers up.  That is,
        ## they're executed both when the system first boots and when
        ## it resumes from suspend or hibernation.
        ##powerUpCommands = ''${pkgs.hdparm}/sbin/hdparm -B 255 /dev/sda'';
        ## Commands executed when the machine powers down.  That is,
        ## they're executed both when the system shuts down and when
        ## it goes to suspend or hibernation.
        ##powerDownCommands = ''${pkgs.hdparm}/sbin/hdparm -B 255 /dev/sda'';
      };
    })

    (mkIf (cfg.hibernate.enable && cfg.resumeDevice != "") {
      #(mkIf cfg.hibernate.enable {
      # Hibernation
      ## Hibernation requires a configured swap device.
      ## go to hibernation by running: systemctl hibernate
      boot.resumeDevice = cfg.resumeDevice;

      ## Go into hibernate after specific suspend time
      ## system will go from suspend into hibernate after 1 hour
      #systemd.sleep.extraConfig = ''
      #  HibernateDelaySec=1h
      #'';
    })

    ## https://wiki.archlinux.org/title/Laptop_Mode_Tools
    ### Laptop Mode Tools is a laptop power saving package for Linux systems.
    ### It is the primary way to enable the Laptop Mode feature of the Linux kernel, which lets your hard drive spin down.
    ### In addition, it allows you to tweak a number of other power-related settings using a simple configuration file.
    ### Combined with acpid and CPU frequency scaling, LMT provides most users with a complete notebook power management suite.

    ## https://wiki.archlinux.org/title/Hdparm
    ## hdparm and sdparm are command line utilities to set and view hardware parameters of hard disk drives

    ## Nixos: https://wiki.nixos.org/wiki/Laptop
    ### A common tool used to save power on laptops is TLP, which has sensible defaults for most laptops.

    (mkIf cfg.laptop.enable {
      ## https://wiki.archlinux.org/title/TLP
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

      ## TODO
      ## DPMS
      ### https://wiki.archlinux.org/title/Display_Power_Management_Signaling

      ## screen brightness
      programs.light.enable = true;
      services.actkbd = {
        enable = true;
        bindings = [
          #{ keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
          #{ keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
          {
            keys = [cfg.laptop.lightUpKey];
            events = ["key"];
            command = "/run/current-system/sw/bin/light -U 10";
          }
          {
            keys = [cfg.laptop.lightDownKey];
            events = ["key"];
            command = "/run/current-system/sw/bin/light -A 10";
          }
        ];
      };
    })

    ## TODO
    #(mkIf cfg.isPC {
    #  })

    ## TODO
    ### https://github.com/nix-community/srvos/blob/main/nixos/server/default.nix
    (mkIf cfg.server.enable {
      systemd = {
        # Given that our systems are headless, emergency mode is useless.
        # We prefer the system to attempt to continue booting so
        # that we can hopefully still access it remotely.
        enableEmergencyMode = false;

        # For more detail, see:
        #   https://0pointer.de/blog/projects/watchdog.html
        watchdog = {
          # systemd will send a signal to the hardware watchdog at half
          # the interval defined here, so every 10s.
          # If the hardware watchdog does not get a signal for 20s,
          # it will forcefully reboot the system.
          runtimeTime = "20s";
          # Forcefully reboot if the final stage of the reboot
          # hangs without progress for more than 30s.
          # For more info, see:
          #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
          rebootTime = "30s";
        };

        sleep.extraConfig = ''
          AllowSuspend=no
          AllowHibernation=no
        '';
      };
    })

    ## TODO
    ## https://wiki.archlinux.org/title/Wake-on-LAN

    ## TODO
    ## http://blog.lujun9972.win/blog/2018/12/31/%E4%BD%BF%E7%94%A8rtcwake%E5%AE%9A%E6%97%B6%E5%94%A4%E9%86%92linux/index.html
    ## Sleep in time
    ## Wake up in time
  ]);
}
# Summary
## reference
## http://blog.lujun9972.win/blog/2018/06/21/linux%E5%AE%9A%E6%97%B6%E4%BC%91%E7%9C%A0/
## 目前大概由三种类型的休眠:
### suspend(suspend to RAM)
### 指的是除了内存以外的大部分机器部件都进入断电状态
### 这种休眠状态恢复速度特别快，但由于内存中的数据并没有被保存下来
### 因此这个状态的系统并没有进入真正意义上的休眠状态，还在持续耗电
### hibernate(suspend to disk)
### 这种休眠会将内存中的系统状态写入交换空间内
### 当系统启动时就可以从交换空间内读回系统状态
### 这种情况下系统可以完全断电,但由于要保存/读取系统状态到/从交换空间，因此速度会比较慢，而且需要进行一些配置
### hybrid(suspend to both)
### 结合了上面两种休眠类型
### 它像 hibernate 一样将系统状态存入交换空间内
### 同时也像 suspend 一样并不关闭电源
### 这种，在电源未耗尽之前，它能很快的从休眠状态恢复
### 而若休眠期间电源耗尽，则它可以从交换空间中恢复系统状态
# Finally
## man systemd-sleep
### systemd-suspend.service
### systemd-hibernate.service
### systemd-hybrid-sleep.service
### /usr/lib/systemd/system-sleep

