# reference
## https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix
{
  config,
  options,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.vscodium;
  extensions = inputs.nix-vscode-extensions.extensions."x86_64-linux";
  jsonFormat = pkgs.formats.json {};
  vscodeUserSettings = {
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.colorTheme" = "Catppuccin Macchiato";
    "workbench.panel.defaultLocation" = "right";
    "workbench.startupEditor" = "none";
    "workbench.list.smoothScrolling" = true;

    "catppuccin.accentColor" = "mauve";

    "editor.fontFamily" = "JetBrainsMono Nerd Font, Material Design Icons";
    "editor.fontSize" = 15;
    "editor.fontLigatures" = true;

    "files.trimTrailingWhitespace" = false;

    "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font Mono";
    "terminal.integrated.defaultProfile.linux" = "zsh";
    "terminal.integrated.cursorBlinking" = true;

    "editor.minimap.enabled" = false;
    "editor.minimap.renderCharacters" = false;
    "editor.overviewRulerBorder" = false;
    "editor.renderLineHighlight" = "all";
    "editor.inlineSuggest.enabled" = true;
    "editor.smoothScrolling" = true;
    "editor.suggestSelection" = "first";
    "editor.guides.indentation" = false;

    "[nix]"."editor.tabSize" = 2;

    "window.restoreWindows" = "all";
    "window.menuBarVisibility" = "toggle";
    "window.titleBarStyle" = "custom";

    "security.workspace.trust.enabled" = false;

    "explorer.confirmDelete" = true;

    "breadcrumbs.enabled" = true;
    "update.mode" = "none";
    "extensions.autoCheckUpdates" = false;
  };
in {
  options.modules.editors.vscodium = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.unstable; [
      alejandra
      yamlfmt
      shfmt
      (vscode-with-extensions.override {
        vscode = vscodium;
        vscodeExtensions =
          (with extensions.vscode-marketplace; [
            # ui
            pkief.material-icon-theme
            catppuccin.catppuccin-vsc
            naumovs.color-highlight
            ibm.output-colorizer
            wayou.vscode-todo-highlight

            # format
            esbenp.prettier-vscode
            oderwat.indent-rainbow
            shardulm94.trailing-spaces

            # error
            usernamehw.errorlens

            # code runner
            formulahendry.code-runner

            # comments
            aaron-bond.better-comments

            # nix
            bbenoist.nix
            kamadorueda.alejandra
            arrterian.nix-env-selector

            # debug
            vadimcn.vscode-lldb

            # shell
            rogalmic.bash-debug
            shakram02.bash-beautify
            foxundermoon.shell-format

            # python
            ms-python.python
            ms-python.vscode-pylance
            ms-python.debugpy
            ms-python.isort

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
            serayuzgur.crates
            tamasfe.even-better-toml
            jscearcy.rust-doc-viewer
            zhangyue.rust-mod-generator
            swellaby.vscode-rust-test-adapter
            conradludgate.rust-playground

            # docker
            ms-azuretools.vscode-docker

            # remote dev
            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-containers

            # vim keybindings
            vscodevim.vim

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

            # git
            github.codespaces
            github.vscode-pull-request-github
            eamodio.gitlens
            donjayamanne.githistory
            mhutchie.git-graph

            # r
            reditorsupport.r
            rdebugger.r-debugger

            # snakemake
            snakemake.snakemake-lang
            tfehlmann.snakefmt

            # nextflow
            nextflow.nextflow

            # web
            octref.vetur
            christian-kohler.path-intellisense
            formulahendry.auto-close-tag
            batisteo.vscode-django
          ])
          ++ (with extensions.open-vsx; [
            #ms-vscode.cpptools #error: attribute 'cpptools' missing
          ]);
      })
    ];

    #vscodePname = cfg.package.pname;
    #configDir =
    #  {
    #    "vscode" = "Code";
    #    "vscode-insiders" = "Code - Insiders";
    #    "vscodium" = "VSCodium";
    #    "openvscode-server" = "OpenVSCode Server";
    #  }
    #  .${vscodePname};
    # => configDir => VSCodium

    #extensionDir =
    #  {
    #    "vscode" = "vscode";
    #    "vscode-insiders" = "vscode-insiders";
    #    "vscodium" = "vscode-oss";
    #    "openvscode-server" = "openvscode-server";
    #  }
    #  .${vscodePname};
    # => extensionDir => vscode-oss

    #userDir = "${config.xdg.configHome}/${configDir}/User";
    # => userDir => ~/.config/VSCodium/User

    #configFilePath = "${userDir}/settings.json";
    # => ~/.config/VSCodium/User/settings.json

    #tasksFilePath = "${userDir}/tasks.json";
    # => ~/.config/VSCodium/User/tasks.json

    #keybindingsFilePath = "${userDir}/keybindings.json";
    # => ~/.config/VSCodium/User/keybindings.json

    #snippetDir = "${userDir}/snippets";
    # => ~/.config/VSCodium/User/snippets

    #extensionPath = ".${extensionDir}/extensions";
    # => .vscode-oss/extensions

    home.configFile = {
      "VSCodium/User/settings.json".source = jsonFormat.generate "vscode-user-settings" vscodeUserSettings;
    };
  };
}
