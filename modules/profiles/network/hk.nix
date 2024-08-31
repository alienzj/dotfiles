# modules/profiles/network/ca.nix --- TODO
{
  hey,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib;
  mkIf (elem "hk" config.modules.profiles.networks) {
    time.timeZone = "Asia/Hong_Kong";

    # For redshift, mainly
    location = {
      latitude = 22.43;
      longitude = 114.21;
    };
  }
