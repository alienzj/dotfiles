# Emacs is my main driver. I'm the author of Doom Emacs
# https://github.com/doomemacs. This module sets it up to meet my particular
# Doomy needs.
{
  hey,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.editors.emacs;
  emacs = with pkgs;
    (emacsPackagesFor
      (
        if config.modules.desktop.type == "wayland"
        then emacs-pgtk
        else emacs-git
      ))
    .emacsWithPackages (epkgs:
      with epkgs; [
        # treesit-grammars.with-all-grammars
        vterm
      ]);
in {
  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
    # doom = rec {
    #   enable = mkBoolOpt false;
    #   forgeUrl = mkOpt types.str "https://github.com";
    #   repoUrl = mkOpt types.str "${forgeUrl}/doomemacs/doomemacs";
    #   configRepoUrl = mkOpt types.str "${forgeUrl}/alienzj/doom.d";
    # };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      hey.inputs.emacs-overlay.overlays.default
    ];

    user.packages = with pkgs; [
      (mkLauncherEntry "Emacs (Debug Mode)" {
        description = "Start Emacs in debug mode";
        icon = "emacs";
        exec = "${emacs}/bin/emacs --debug-init";
      })

      ## Emacs itself
      binutils # native-comp needs 'as', provided by this
      # HEAD + native-comp
      emacs

      ## Doom dependencies
      git
      ripgrep
      gnutls # for TLS connectivity

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      (mkIf (config.programs.gnupg.agent.enable)
        pinentry-emacs) # in-emacs gnupg prompts
      zstd # for undo-fu-session/undo-tree compression

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [en en-computers en-science]))
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang beancount
      beancount
      fava
      # :lang nix
      age
    ];

    environment.variables.PATH = ["$XDG_CONFIG_HOME/emacs/bin"];

    modules.shell.zsh.rcFiles = ["${hey.configDir}/emacs/aliases.zsh"];

    fonts.packages = [
      (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };
}
