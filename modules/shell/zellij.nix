{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.zellij;
in {
  options.modules.shell.zellij = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = [ 
        pkgs.zellij
      ];
    }
  ]);
}
