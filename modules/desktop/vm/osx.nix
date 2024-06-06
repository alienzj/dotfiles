{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
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
