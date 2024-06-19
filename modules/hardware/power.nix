# reference
## https://wiki.archlinux.org/title/Category:Power_management
## https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate
## TODO
## FIXME
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
    resumeDevice = mkOpt types.str "/dev/disk/by-label/swap";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        acpi
        powertop
      ];

      powerManagement = {
        enable = true;
        cpuFreqGovernor = cfg.cpuFreqGovernor;
        powertop.enable = true;
      };
    }

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

      services.auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
          };
          charger = {
            governor = "performance";
            turbo = "auto";
          };
        };
      };

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

    (mkIf cfg.isPC {
      })
  ]);
}
