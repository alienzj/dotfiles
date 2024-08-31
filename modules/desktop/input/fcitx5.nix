{
  hey,
  lib,
  options,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.desktop.input.fcitx5;
  # way 1
  #fcitx5Package =
  #  pkgs.libsForQt5.fcitx5-with-addons.override {inherit (cfg) addons;};
in {
  options.modules.desktop.input.fcitx5 = {
    enable = mkBoolOpt false;
    # way 1
    #addons = mkOption {
    #  type = with types; listOf package;
    #  default = [pkgs.fcitx5-rime];
    #  example = literalExpression "with pkgs; [ fcitx5-rime ]";
    #  description = ''
    #    Enabled Fcitx5 addons.
    #  '';
    #};
  };

  config = mkIf cfg.enable (mkMerge [
    {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";

        # way 1
        #package = lib.mkForce fcitx5Package;
        # way 2
        fcitx5.addons = [pkgs.fcitx5-rime];
      };

      # way 1
      #environment.sessionVariables = {
      #  GLFW_IM_MODULE = "ibus"; # IME support in kitty
      #  GTK_IM_MODULE = "fcitx";
      #  QT_IM_MODULE = "fcitx";
      #  XMODIFIERS = "@im=fcitx";
      #  QT_PLUGIN_PATH = lib.mkForce "$QT_PLUGIN_PATH\${QT_PLUGIN_PATH:+:}${fcitx5Package}/${pkgs.qt6.qtbase.qtPluginPrefix}";
      #};

      # way 1
      systemd.user.services.fcitx5-daemon = {
        description = "Fcitx5 input method editor";
        after = ["graphical.target"];
        wantedBy = ["graphical.target"];
        serviceConfig = {
          #ExecStart = "${fcitx5Package}/bin/fcitx5";
          ExecStart = "fcitx5";
          Restart = "on-abort";
        };
      };
    }
  ]);
}
