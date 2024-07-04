{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.input.fcitx5;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.input.fcitx5 = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      i18n.inputMethod = {
        enabled = "fcitx5";
        addons = [pkgs.fcitx5-rime];
      };

      systemd.user.services.fcitx5-daemon = {
        Unit = {
          description = "Fcitx5 input method editor";
          PartOf = ["graphical.target"];
        };
        Service.ExecStart = "${fcitx5Package}/bin/fcitx5";
        Install.WantedBy = ["graphical.target"];
      };
    }
  ]);
}
