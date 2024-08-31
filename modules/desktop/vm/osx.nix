{
  hey,
  lib,
  config,
  options,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.desktop.vm.osx;
in {
  options.modules.desktop.vm.osx = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      dnsmasq
      flex
      bison
      edk2
      bridge-utils
    ];
  };
}
