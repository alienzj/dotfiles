# modules/profiles/network/sz.nix --- TODO
# https://en.wikipedia.org/wiki/Shenzhen
{
  hey,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib;
  mkIf (elem "sz" config.modules.profiles.networks) {
    time.timeZone = "Asia/Hong_Kong";

    # For redshift, mainly
    location = {
      latitude = 22.55;
      longitude = 114.23;
    };
  }
