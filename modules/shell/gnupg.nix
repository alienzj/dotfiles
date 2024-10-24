# reference
## https://github.com/ryan4yin/nix-config/tree/main/home/base/tui/gpg
## https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/gnupg.nix
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.gnupg;
in {
  options.modules.shell.gnupg = with types; {
    enable = mkBoolOpt false;
    cacheTTL = mkOpt int 3600; # 1hr
  };

  # TODO
  ## more detailed configuration
  config = mkIf cfg.enable {
    environment.variables.GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";

    programs.gnupg.agent.enable = true;

    user.packages = [pkgs.tomb];

    # HACK Without this config file you get "No pinentry program" on 20.03.
    #      programs.gnupg.agent.pinentryFlavor doesn't appear to work, and this
    #      is cleaner than overriding the systemd unit.
    home.configFile."gnupg/gpg-agent.conf" = {
      text = ''
        default-cache-ttl ${toString cfg.cacheTTL}
        pinentry-program ${pkgs.pinentry}/bin/pinentry
      '';
    };
  };
}
