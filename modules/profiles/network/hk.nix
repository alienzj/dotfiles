# modules/profiles/network/hk.nix --- TODO
# https://en.wikipedia.org/wiki/Hong_Kong
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
      latitude = 22.30;
      longitude = 114.17;
    };
  }
