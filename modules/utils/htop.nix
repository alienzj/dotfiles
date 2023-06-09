{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.utils.htop;
in {
  options.modules.utils.htop = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      #unstable.htop
      unstable.hydra-check
      unstable.bandwhich
      unstable.zenith
      unstable.nvtop
      unstable.ctop
      #unstable.bpytop
      unstable.btop
      unstable.visidata
    ];
  };
}
