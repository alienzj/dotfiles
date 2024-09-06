# profiles/hardware/pc/laptop.nix ---
# reference
## https://www.kernel.org/doc/html/latest/admin-guide/pm/
## https://wiki.archlinux.org/title/Category:Power_management
## https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate
## https://wiki.archlinux.org/title/Power_management/Wakeup_triggers
## https://wiki.nixos.org/wiki/Power_Management
## https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/power-management.nix
## https://github.com/huataihuang/cloud-atlas-draft/blob/master/os/linux/redhat/system_administration/systemd/hibernate_with_fedora_in_laptop.md
## 设置Hibernate休眠模式关键点是设置足够存储笔记本内存内容的swap空间，否则会导致hibernate失败
## adjust swap size if you using LVM
## https://baldpenguin.blogspot.com/2016/03/enabling-hibernation-in-fedora-23.html
## https://github.com/huataihuang/cloud-atlas-draft/tree/master/os/linux/storage/device-mapper/lvm
# resumeDevice = mkOpt types.str "/dev/disk/by-label/swap";
# TODO
{
  hey,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  hardware = config.modules.profiles.hardware;
in
  mkMerge [
    (mkIf (any (s: hasPrefix "pc/laptop" s) hardware) {
      user.packages = with pkgs; [
        brightnessctl # instead of programs.light
        acpi

        # Powertop is a power analysis tool
        ## https://wiki.archlinux.org/title/Powertop
        ## gerenate report
        ## powertop --html=powerreport.html
        #powertop
      ];

      #powerManagement = {
      #  enable = true;
      #  cpuFreqGovernor = cfg.cpuFreqGovernor;
      #  powertop.enable = true;

      #  ## TODO
      #  ## FIXME
      #  ## Commands executed after the system resumes from suspend-to-RAM.
      #  ##resumeCommands = "";
      #  ## Commands executed when the machine powers up.  That is,
      #  ## they're executed both when the system first boots and when
      #  ## it resumes from suspend or hibernation.
      #  ##powerUpCommands = ''${pkgs.hdparm}/sbin/hdparm -B 255 /dev/sda'';
      #  ## Commands executed when the machine powers down.  That is,
      #  ## they're executed both when the system shuts down and when
      #  ## it goes to suspend or hibernation.
      #  ##powerDownCommands = ''${pkgs.hdparm}/sbin/hdparm -B 255 /dev/sda'';
      #};

      ## https://wiki.archlinux.org/title/Laptop_Mode_Tools
      ### Laptop Mode Tools is a laptop power saving package for Linux systems.
      ### It is the primary way to enable the Laptop Mode feature of the Linux kernel, which lets your hard drive spin down.
      ### In addition, it allows you to tweak a number of other power-related settings using a simple configuration file.
      ### Combined with acpid and CPU frequency scaling, LMT provides most users with a complete notebook power management suite.

      ## https://wiki.archlinux.org/title/Hdparm
      ## hdparm and sdparm are command line utilities to set and view hardware parameters of hard disk drives

      ## Nixos: https://wiki.nixos.org/wiki/Laptop
      ### A common tool used to save power on laptops is TLP, which has sensible defaults for most laptops.

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
          #laptop.lightUpKey = 63;
          #laptop.lightDownKey = 64;

          #{ keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
          #{ keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }

          {
            #keys = [cfg.laptop.lightUpKey];
            keys = [63];

            events = ["key"];
            command = "/run/current-system/sw/bin/light -U 10";
          }
          {
            #keys = [cfg.laptop.lightDownKey];
            keys = [64];
            events = ["key"];
            command = "/run/current-system/sw/bin/light -A 10";
          }
        ];
      };

      # So the system can respond to power events
      # services.udev.extraRules = ''
      #   SUBSYSTEM=="power_supply",ENV{POWER_SUPPLY_ONLINE}=="0",RUN+="${hey.binDir}/hey hook battery --discharging"
      #   SUBSYSTEM=="power_supply",ENV{POWER_SUPPLY_ONLINE}=="1",RUN+="${hey.binDir}/hey hook battery --charging"
      # '';

      # # And so I can monitor the charge level
      # systemd.user.services.battery_monitor = {
      #   wants = [ "display-manager.service" ];
      #   wantedBy = [ "graphical-session.target" ];
      #   script = ''
      #     export PATH="${pkgs.acpi}/bin:${hey.binDir}:$PATH"
      #     while true; do
      #       IFS=: read _ bat0 < <(acpi -b)
      #       IFS=\ , read status val remaining <<<"$bat0"
      #       local wait=$(hey hook battery --poll "$status" "$${val%\%}" "$remaining")
      #       sleep $${wait:-1m}
      #     done
      #   '';
      # };

      # systemd.user.services.battery_monitor = {
      #   wants = [ "display-manager.service" ];
      #   wantedBy = [ "graphical-session.target" ];
      #   script = ''
      #     prev_val=100
      #     _check () {
      #       [[ $1 -ge $val ]] && [[ $1 -lt $prev_val ]];
      #     }
      #     _notify () {
      #       ${pkgs.libnotify}/bin/notify-send \
      #         --app-name battery \
      #         --hint string:x-dunst-stack-tag:battery \
      #         --hint "int:value:$val" \
      #         "$@" "$val%, $remaining"
      #     }
      #     while true; do
      #       ifs=: read _ bat0 < <(${pkgs.acpi}/bin/acpi -b)
      #       ifs=\ , read status val remaining <<<"$bat0"
      #       val=''${val%\%}
      #       if [[ "x$status" = xdischarging ]]; then
      #         echo "$val%, $remaining"
      #         if _check 30 || _check 15; then
      #           _notify "Battery low"
      #         elif _check 10; then
      #           _notify -u critical "Battery critical"
      #         fi
      #       fi
      #       prev_val=$val
      #       # sleep longer when battery is high to save cpu
      #       if [[ $val -gt 30 ]]; then
      #         sleep 10m
      #       elif [[ $val -ge 20 ]]; then
      #         sleep 5m
      #       else
      #         sleep 1m
      #       fi
      #     done
      #   '';
      # };
    })
  ]
