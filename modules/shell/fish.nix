{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.fish;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.fish = with types; {
    enable = mkBoolOpt false;

    aliases = mkOpt (attrsOf (either str path)) {};

    rcInit = mkOpt' lines "" ''
      Fish lines to be written to $XDG_CONFIG_HOME/fish/extraconfig.fish and sourced by
      $XDG_CONFIG_HOME/fish/config.fish
    '';

    rcFiles = mkOpt (listOf (either str path)) [];
  };

  config = mkIf cfg.enable {
    #users.defaultUserShell = pkgs.bash; # default user shell is zsh, see zsh.nix

    #programs.bash = {
    #  interactiveShellInit = ''
    #    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    #    then
    #      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
    #      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    #    fi
    #  '';
    #};

    environment.systemPackages = with pkgs; [
      fishPlugins.done
      fishPlugins.fzf-fish
      fishPlugins.forgit
      fishPlugins.hydro
      fzf
      fishPlugins.grc
      grc
    ];

    programs.fish = {
      enable = true;
      useBabelfish = false;
      promptInit = "";
    };

    user.packages = with pkgs; [
      fish
      starship
    ];

    env = {
      FISHDOTDIR = "$XDG_CONFIG_HOME/fish";
      FISH_CACHE = "$XDG_CACHE_HOME/fish";
    };

    #home.configFile = {
    #  # Write it recursively so other modules can write files to it
    #  "fish" = { source = "${configDir}/fish"; recursive = true; };

    #  "fish/extraconfig.fish".text = ''
    #    ${concatMapStrings (path: "source '${path}'\n") cfg.rcFiles}
    #    ${cfg.rcInit}
    #  '';

    #  #"fish/functions/fish_prompt.fish".text = ''
    #  #  set -l nix_shell_info (
    #  #    if test -n "$IN_NIX_SHELL"
    #  #      echo -n "<nix-shell> "
    #  #    end
    #  # )
    #  #'';
    #};
  };
}
