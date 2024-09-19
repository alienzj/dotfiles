# hosts/server.nix
#
# Only to be used for headless servers, at home or abroad, with more
# security/automation-minded configuration.
{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_15_hardened;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 21d";
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

  ## Security tweaks
  boot.kernelPackages = mkForce pkgs.unstable.linuxKernel.packages.linux_6_9_hardened;
  # Prevent replacing the running kernel w/o reboot
  security.protectKernelImage = true;
}
