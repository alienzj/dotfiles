      #"editor.formatOnPaste" = true;
      #"editor.formatOnSave" = true;
      #"editor.formatOnType" = false;
      #"terminal.integrated.automationShell.linux" = "nix-shell";

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vscodium;
    jsonFormat = pkgs.formats.json { };
    vscodeUserSettings = {
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.colorTheme" = "Catppuccin Macchiato";
      "catppuccin.accentColor" = "mauve";
      "editor.fontFamily" = "JetBrainsMono Nerd Font, Material Design Icons";
      "editor.fontSize" = 15;
      "editor.fontLigatures" = true;
      "workbench.fontAliasing" = "antialiased";
      "files.trimTrailingWhitespace" = true;
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
  options.modules.editors.vscodium = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      (vscode-with-extensions.override {
        vscode = vscodium;
        vscodeExtensions = with vscode-extensions; [

          # ui
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
		
          # nix 
          bbenoist.nix
	  kamadorueda.alejandra
	  arrterian.nix-env-selector
          
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
	  matklad.rust-analyzer

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

	  # tex
          james-yu.latex-workshop

          # haskell
          haskell.haskell
          justusadam.language-haskell

          # go
          golang.go

	  # github
	  github.codespaces

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
	    version = "0.5.0";
	    sha256 = "94f86eddd480c2a28079dd92392e63bdfa15b71728fcb1a022111382806bcf87";
	  }
	  {
	    name = "nextflow"; 
	    publisher = "nextflow";
	    version = "0.3.1";
	    sha256 = "8274104e7702c5925f449dcf9e6659e0cdf8a9b0b6ec437922a28af43b006ab6";
	  }
	  #{
	  #  name = "nf-core"; 
	  #  publisher = "nf-core-extensionpack";
	  #  version = "0.4.0";
	  #  sha256 = "d1e090b808cea0101851ab5bcd6c5a1a3b82e389f7b6cb5521e9b2266aaa7ce7";
	  #}
        ];
      })
    ];
 
    home.configFile = {
      "VSCodium/User/settings.json".source = jsonFormat.generate "vscode-user-settings" vscodeUserSettings;
    };
  };
}
