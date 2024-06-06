{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.utils.youdl;
in {
  options.modules.utils.youdl = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.you-get
      unstable.youtube-dl
      unstable.yutto
      unstable.yt-dlp
    ];
  };
}
