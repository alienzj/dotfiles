{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vscode;
    jsonFormat = pkgs.formats.json { };
    vscodeUserSettings = {
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.colorTheme" = "Catppuccin Macchiato";
      "catppuccin.accentColor" = "mauve";
      "editor.fontFamily" = "JetBrainsMono Nerd Font, Material Design Icons";
      "editor.fontSize" = 16;
      "editor.fontLigatures" = true;
      "workbench.fontAliasing" = "antialiased";
      "files.trimTrailingWhitespace" = true;
      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font Mono";
      "window.titleBarStyle" = "custom";
      "terminal.integrated.automationShell.linux" = "nix-shell";
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.enableBell" = false;
      "editor.defaultFormatter" = "xaver.clang-format";
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnType" = false;
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
      "workbench.editor.tabCloseButton" = "left";
      "workbench.startupEditor" = "none";
      "workbench.list.smoothScrolling" = true;
      "security.workspace.trust.enabled" = false;
      "explorer.confirmDelete" = false;
      "breadcrumbs.enabled" = true;
      "update.mode" = "none";
      "extensions.autoCheckUpdates" = false;
    };
in {
  options.modules.editors.vscode = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          pkief.material-icon-theme
	  catppuccin.catppuccin-vsc

          naumovs.color-highlight
          oderwat.indent-rainbow
          ibm.output-colorizer
          shardulm94.trailing-spaces
          usernamehw.errorlens
          eamodio.gitlens
	  christian-kohler.path-intellisense
	  formulahendry.code-runner

          bbenoist.nix
	  kamadorueda.alejandra

          ms-python.python
	  ms-toolsai.jupyter

	  ms-vscode.cpptools

	  matklad.rust-analyzer

          ms-azuretools.vscode-docker
          ms-vscode-remote.remote-ssh

	  vscodevim.vim

	  bungcip.better-toml
	  mechatroner.rainbow-csv
          redhat.vscode-yaml
          yzhang.markdown-all-in-one
          james-yu.latex-workshop

          haskell.haskell
          justusadam.language-haskell

          golang.go
        ] ++ pkgs.unstable.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "remote-ssh-edit";
            publisher = "ms-vscode-remote";
            version = "0.84.0";
	    sha256 = "df78c7582f0ad135891b9e26e85aa7604a2d2aa37191c77f0f5e13173e9d8267";
          }
          {
	    name = "snakemake-lang";
	    publisher = "Snakemake";
	    version = "0.1.8";
	    sha256 = "6496bf416792dc4ed7385004ec57d5ca41cc6b1ead31b1b21194cf270c177b5b";
          }
	  {
	    name = "snakefmt"; 
	    publisher = "tfehlmann";
	    version = "0.4.0";
	    sha256 = "ede5491656ef1ef24349a4bd5c5e320de5b253b9ab9f6d17d1d5a1320dff4d64";
	  }
        ];
      })
    ];
    
    home.configFile = {
      "Code/User/settings.json".source = jsonFormat.generate "vscode-user-settings" vscodeUserSettings;
    };
  };
}
