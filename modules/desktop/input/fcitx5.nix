{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.input.fcitx5;
    configDir = config.dotfiles.configDir;
    #fcitx5Package = pkgs.fcitx5-with-addons.override { inherit (cfg) addons; };
in {
  options = {
    modules.desktop.input.fcitx5 = {
      enable = mkBoolOpt types.false;
    #  addons = mkOption {
    #    type = with types; listOf package;
    #    default = [ ];
    #    example = literalExpression "with pkgs; [ fcitx5-rime ]";
    #    description = ''
    #      Enabled Fcitx5 addons.
    #    '';
    #  };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      i18n.inputMethod = {
        enabled = "fcitx5";
        #fcitx.engines = with pkgs; [ rime ];
        fcitx5.addons = with pkgs; [
          fcitx5-rime
          #fcitx5-mozc
          fcitx5-chinese-addons
          fcitx5-gtk
        ];
      };

      #i18n.inputMethod.enabled = "fcitx5";
      #i18n.inputMethod.package = fcitx5Package;

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
      };

      #systemd.user.services.fcitx5-daemon = {
      #  Unit = {
      #    Description = "Fcitx5 input method editor";
      #    PartOf = [ "graphical-session.target" ];
      #  };
      #  Service.ExecStart = "${fcitx5Package}/bin/fcitx5";
      #  Install.WantedBy = [ "graphical-session.target" ];
      #};
    }
  ]);
}
