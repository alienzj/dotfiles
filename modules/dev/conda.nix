{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev.conda;
in {
  options.modules.dev.conda = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        (conda.override {installationPath = "~/.conda/envs/base";})
      ];
    }
  ]);
}
