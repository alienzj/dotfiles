{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vscode;
in {
  options.modules.editors.vscode = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    #user.packages = with pkgs; [
    #  unstable.vscode
    #];

    #programs.vscode = {
    #  enable = true;
    #  #package = pkgs.vscodium;
    #  extensions = with pkgs.vscode-extensions; [
    #    ms-python.python
    #  ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    #    {
    #      name = "remote-ssh-edit";
    #      publisher = "";
    #      version = "";
    #      sha256 = "";
    #    }
    #    {
    #      name = "snakemake-lang";
    #      publisher = "";
    #      version = "";
    #      sha256 = "";
    #    }
    #    {
    #      name = "snakefmt";
    #      publisher = "";
    #      version = "";
    #      sha256 = "";
    #    }
    #  ];
    #  userSettings = {
    #    "[nix]" = {
    #      "editor.tabSize" = 2;
    #     };
    #  };
    #  "workbench.colorTheme" = "One Dark Pro";
    #};

    user.packages = with pkgs; [
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
	  # nix
          bbenoist.nix
	  # python
          ms-python.python
	  # jupyter
	  ms-toolsai.jupyter
	  # c/c++
	  ms-vscode.cpptools
	  # rust
	  matklad.rust-analyzer
	  bungcip.better-toml
	  # docker
          ms-azuretools.vscode-docker
	  # remote development
          ms-vscode-remote.remote-ssh
	  # keybindings
	  vscodevim.vim
	  # theme
	  zhuangtongfa.material-theme
	  # csv
	  mechatroner.rainbow-csv
          # yaml
          redhat.vscode-yaml
          # haskell
          haskell.haskell
          justusadam.language-haskell
          # latex
          james-yu.latex-workshop
          # go
          golang.go
          # markdown
          yzhang.markdown-all-in-one
	  # code runner
	  formulahendry.code-runner
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
  };
}
