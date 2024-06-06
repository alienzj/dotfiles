{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.utils.htop;
in {
  options.modules.utils.htop = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # cpu
      unstable.htop
      unstable.btop

      # gpu
      unstable.nvtopPackages.full
      unstable.gpu-viewer
      unstable.gpustat
      unstable.nvitop

      # docker
      unstable.ctop

      # network
      unstable.bandwhich
      unstable.zenith
      unstable.sniffnet

      # data
      unstable.visidata

      # nix
      unstable.hydra-check
    ];
  };
}
