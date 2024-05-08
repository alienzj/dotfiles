{ options, config, inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.im.wechat;
in {
  options.modules.desktop.im.wechat = with types; {
    enable = mkBoolOpt false;
  };

  imports = [ inputs.nur.nixosModules.nur ];

  config = mkIf cfg.enable {
    #nixpkgs.overlays = [ inputs.nur.overlay ];

    user.packages = [
      config.nur.repos.xddxdd.wechat-uos
    ];
  };
}
