{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.android-studio;
in {
  options.modules.editors.android-studio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      android-tools
      android-file-transfer
      android-studio

      payload-dumper-go
    ];
  };
}
