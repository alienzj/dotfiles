# modules/profiles/network/yx.nix --- TODO
# https://en.wikipedia.org/wiki/Yangxin_County,_Hubei
{
  hey,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib;
  mkIf (elem "yx" config.modules.profiles.networks) {
    time.timeZone = "Asia/Shanghai";

    # For redshift, mainly
    location = {
      latitude = 29.71;
      longitude = 115.26;
    };
  }
