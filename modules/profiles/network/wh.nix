# modules/profiles/network/wh.nix --- TODO
# https://en.wikipedia.org/wiki/Wuhan
{
  hey,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib;
  mkIf (elem "wh" config.modules.profiles.networks) {
    time.timeZone = "Asia/Shanghai";

    # For redshift, mainly
    location = {
      latitude = 30.59;
      longitude = 114.30;
    };
  }
