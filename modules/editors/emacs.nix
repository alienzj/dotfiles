# Emacs is my main driver. I'm the author of Doom Emacs
# https://github.com/hlissner/doom-emacs. This module sets it up to meet my
# particular Doomy needs.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.emacs;
  configDir = config.dotfiles.configDir;
in {
  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
    doom = rec {
      enable = mkBoolOpt false;
      forgeUrl = mkOpt types.str "https://github.com";
      repoUrl = mkOpt types.str "${forgeUrl}/doomemacs/doomemacs";
      configRepoUrl = mkOpt types.str "${forgeUrl}/hlissner/doom-emacs-private";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [inputs.emacs-overlay.overlay];

    user.packages = with pkgs; [
      ## Emacs itself
      #binutils # native-comp needs 'as', provided by this
      # 28.2 + native-comp
      #((emacsPackagesFor emacsNativeComp).emacsWithPackages
      #((emacsPackagesFor emacs).emacsWithPackages
      #((emacsPackagesFor emacs-unstable).emacsWithPackages
      ((emacsPackagesFor emacs-git).emacsWithPackages
        (epkgs: with epkgs; [
          vterm
          pdf-tools
          melpaStablePackages.pdf-tools
          treesit-grammars.with-all-grammars
          mu4e
      ]))
      
      binutils
      poppler

      ## Doom dependencies
      #git
      #(ripgrep.override {withPCRE2 = true;})
      gnutls # for TLS connectivity

      ## Optional dependencies
      #fd
      imagemagick # for image-dired
      (mkIf (config.programs.gnupg.agent.enable)
        pinentry-emacs) # in-emacs gnupg prompts
      zstd # for undo-fu-session/undo-tree compression
      graphviz # dot

      # nix
      nixfmt-rfc-style
      #nixd
      #nixdoc
      #nix-nil
      #nixd-lsp
      #rnix-lsp
      dockfmt
      rstfmt
      plantuml

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [en en-computers en-science]))
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-full
      ghostscript
      pandoc
      #texlive.combined.scheme-medium
      #texlive.combined.scheme-small
      # :lang beancount
      beancount
      unstable.fava # HACK Momentarily broken on nixos-unstable
    ];

    env.PATH = ["$XDG_CONFIG_HOME/emacs/bin"];

    modules.shell.zsh.rcFiles = ["${configDir}/emacs/aliases.zsh"];

    fonts.packages = [pkgs.emacs-all-the-icons-fonts];

    system.userActivationScripts = mkIf cfg.doom.enable {
      installDoomEmacs = ''
        if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
           git clone --depth=1 --single-branch "${cfg.doom.repoUrl}" "$XDG_CONFIG_HOME/emacs"
           git clone "${cfg.doom.configRepoUrl}" "$XDG_CONFIG_HOME/doom"
        fi
      '';
    };
  };
}
