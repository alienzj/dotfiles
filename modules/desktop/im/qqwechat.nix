{
  hey,
  lib,
  options,
  config,
  pkgs,
  ...
}:
with lib;
with builtins;
with hey.lib; let
  cfg = config.modules.desktop.im.qqwechat;
  license = fetchurl https://raw.githubusercontent.com/nix-community/nur-combined/master/repos/xddxdd/pkgs/uncategorized/wechat-uos/license.tar.gz;
in {
  options.modules.desktop.im.qqwechat = with types; {
    enable = mkBoolOpt false;
  };

  imports = [hey.inputs.nur.nixosModules.nur];

  config = mkIf cfg.enable {
    nixpkgs.overlays = [hey.inputs.nur.overlays.default];

    user.packages = with pkgs.unstable; [
      # pkgs.xdg-user-dirs
      #config.nur.repos.xddxdd.wechat-uos

      qq
      (wechat-uos.override {uosLicense = license;})
    ];

    environment.sessionVariables = {
      WECHAT_DATA_DIR = "$HOME/.local/share/wechat";
    };
  };
}
