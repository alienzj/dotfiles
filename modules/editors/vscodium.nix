#"editor.formatOnPaste" = true;
#"editor.formatOnSave" = true;
#"editor.formatOnType" = false;
#"terminal.integrated.automationShell.linux" = "nix-shell";
#"terminal.integrated.defaultProfile.linux" = "zsh";

{
  config,
  options,
  lib,
  pkgs,
  extensions,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.editors.vscodium;
  jsonFormat = pkgs.formats.json { };
  vscodeUserSettings = {
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.colorTheme" = "Catppuccin Macchiato";
    "catppuccin.accentColor" = "mauve";
    "editor.fontFamily" = "JetBrainsMono Nerd Font, Material Design Icons";
    "editor.fontSize" = 15;
    "editor.fontLigatures" = true;
    "workbench.fontAliasing" = "antialiased";
    "files.trimTrailingWhitespace" = false;
    "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font Mono";
    "window.titleBarStyle" = "custom";
    "terminal.integrated.defaultProfile.linux" = "zsh";
    "terminal.integrated.cursorBlinking" = true;
    "terminal.integrated.enableBell" = false;
    "editor.minimap.enabled" = false;
    "editor.minimap.renderCharacters" = false;
    "editor.overviewRulerBorder" = false;
    "editor.renderLineHighlight" = "all";
    "editor.inlineSuggest.enabled" = true;
    "editor.smoothScrolling" = true;
    "editor.suggestSelection" = "first";
    "editor.guides.indentation" = false;
    "window.nativeTabs" = true;
    "window.restoreWindows" = "all";
    "window.menuBarVisibility" = "toggle";
    "workbench.panel.defaultLocation" = "right";
    "workbench.editor.tabCloseButton" = "right";
    "workbench.startupEditor" = "none";
    "workbench.list.smoothScrolling" = true;
    "security.workspace.trust.enabled" = false;
    "explorer.confirmDelete" = true;
    "breadcrumbs.enabled" = true;
    "update.mode" = "none";
    "extensions.autoCheckUpdates" = false;
  };
in
{
  options.modules.editors.vscodium = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    programs.vscode = {
      enable = true;
      package = pkgs.unstable.vscodium;

      #extensions = with pkgs.unstable.vscode-extensions; [
      extensions = with extensions.vscode-marketplace; [

        # ui
        pkief.material-icon-theme
        catppuccin.catppuccin-vsc
        esbenp.prettier-vscode
        naumovs.color-highlight
        oderwat.indent-rainbow
        ibm.output-colorizer
        shardulm94.trailing-spaces
        usernamehw.errorlens
        christian-kohler.path-intellisense
        formulahendry.code-runner

        # nix
        bbenoist.nix
        kamadorueda.alejandra
        arrterian.nix-env-selector

        # debug
        vadimcn.vscode-lldb

        # python
        ms-python.python
        ms-python.vscode-pylance

        # jupyter
        ms-toolsai.jupyter
        ms-toolsai.jupyter-keymap
        ms-toolsai.jupyter-renderers
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow

        # cpp
        ms-vscode.cpptools
        ms-vscode.cmake-tools
        ms-vscode.makefile-tools
        twxs.cmake

        # rust
        rust-lang.rust-analyzer

        # docker
        ms-azuretools.vscode-docker

        # remote dev
        ms-vscode-remote.remote-ssh

        # vim keybindings
        vscodevim.vim

        # toml
        bungcip.better-toml

        # csv
        mechatroner.rainbow-csv

        # yaml
        redhat.vscode-yaml

        # markdown
        yzhang.markdown-all-in-one

        # svg
        jock.svg

        # pdf
        tomoki1207.pdf

        # tex
        james-yu.latex-workshop

        # haskell
        haskell.haskell
        justusadam.language-haskell

        # go
        golang.go

        # github
        github.codespaces
        github.vscode-pull-request-github

        # git
        eamodio.gitlens
        donjayamanne.githistory

        # r
        reditorsupport.r

        # snakemake
        Snakemake.snakemake-lang
        tfehlmann.snakefmt
      ];
    };

    home.configFile = {
      "Code/User/settings.json".source = jsonFormat.generate "vscode-user-settings" vscodeUserSettings;
    };
  };
}
