{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.fish;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.fish = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    #users.defaultUserShell = pkgs.fish;

    programs.fish = {
      enable = true;
      useBabelfish = false;
      promptInit = "";
    };

    user.packages = with pkgs; [
      fish
      #nix-zsh-completions
      #bat
      #exa
      #fasd
      #fd
      #fzf
      #jq
      #ripgrep
      #tldr
    ];

    #home.configFile = {
    #  # Write it recursively so other modules can write files to it
    #  "fish" = { source = "${configDir}/fish"; recursive = true; };
    #};
  };
}
