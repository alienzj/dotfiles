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
  fcitx5Package = pkgs.libsForQt5.fcitx5-with-addons.override {inherit (cfg) addons;};
in {
  options = {
    modules.desktop.input.fcitx5 = {
      enable = mkBoolOpt false;
      addons = mkOption {
        type = with types; listOf package;
        default = [pkgs.fcitx5-rime];
        example = literalExpression "with pkgs; [ fcitx5-rime ]";
        description = ''
          Enabled Fcitx5 addons.
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      i18n.inputMethod = {
        enabled = "fcitx5";
        package = fcitx5Package;
      };

      #home.configFile = {
      #  "fcitx5" = {
      #    source = "${configDir}/fcitx5";
      #	  recursive = true;
      #	};
      #};

      environment.sessionVariables = {
        GLFW_IM_MODULE = "ibus"; # IME support in kitty
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";
        QT_PLUGIN_PATH = "$QT_PLUGIN_PATH\${QT_PLUGIN_PATH:+:}${fcitx5Package}/${pkgs.qt6.qtbase.qtPluginPrefix}";
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
