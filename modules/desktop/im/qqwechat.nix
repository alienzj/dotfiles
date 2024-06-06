{
  options,
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.im.qqwechat;
in {
  options.modules.desktop.im.qqwechat = with types; {
    enable = mkBoolOpt false;
  };

  imports = [inputs.nur.nixosModules.nur];

  config = mkIf cfg.enable {
    #nixpkgs.overlays = [ inputs.nur.overlay ];

    user.packages = with pkgs; [
      # pkgs.xdg-user-dirs
      config.nur.repos.xddxdd.wechat-uos
      unstable.qq
      #unstable.wechat-uos
    ];

    environment.sessionVariables = {
      WECHAT_DATA_DIR = "$HOME/.local/share/wechat";
    };
  };
}
