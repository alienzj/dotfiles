# profiles/role/server.nix
#
# Used for headless servers, at home or abroad, with more
# security/automation-minded configuration.
{
  hey,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
  mkIf (config.modules.profiles.role == "server") {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    systemd = {
      services.clear-log = {
        description = "Clear >1 month-old logs every week";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=21d";
        };
      };
      timers.clear-log = {
        wantedBy = ["timers.target"];
        partOf = ["clear-log.service"];
        timerConfig.OnCalendar = "weekly UTC";
      };
    };

    ### https://github.com/nix-community/srvos/blob/main/nixos/server/default.nix
    #systemd = {
    #  # Given that our systems are headless, emergency mode is useless.
    #  # We prefer the system to attempt to continue booting so
    #  # that we can hopefully still access it remotely.
    #  enableEmergencyMode = false;

    #  # For more detail, see:
    #  #   https://0pointer.de/blog/projects/watchdog.html
    #  watchdog = {
    #    # systemd will send a signal to the hardware watchdog at half
    #    # the interval defined here, so every 10s.
    #    # If the hardware watchdog does not get a signal for 20s,
    #    # it will forcefully reboot the system.
    #    runtimeTime = "20s";
    #    # Forcefully reboot if the final stage of the reboot
    #    # hangs without progress for more than 30s.
    #    # For more info, see:
    #    #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
    #    rebootTime = "30s";
    #  };

    #  sleep.extraConfig = ''
    #    AllowSuspend=no
    #    AllowHibernation=no
    #  '';
    #};

    ## TODO
    ## https://wiki.archlinux.org/title/Wake-on-LAN

    ## TODO
    ## http://blog.lujun9972.win/blog/2018/12/31/%E4%BD%BF%E7%94%A8rtcwake%E5%AE%9A%E6%97%B6%E5%94%A4%E9%86%92linux/index.html
    ## Sleep in time
    ## Wake up in time

    powerManagement.cpuFreqGovernor = mkDefault "ondemand";
    virtualisation.docker.enableOnBoot = mkDefault true;
    power.ups.mode = mkDefault "netclient";

    ## Security tweaks
    boot.kernelPackages = mkForce pkgs.unstable.linuxKernel.packages.linux_6_9_hardened;
    # Prevent replacing the running kernel w/o reboot
    security.protectKernelImage = true;
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

