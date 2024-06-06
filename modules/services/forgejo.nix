# modules/services/forgejo.nix
#
# Forgejo is essentially a self-hosted github. This modules configures it with the
# expectation that it will be served over an SSL-secured reverse proxy (best
# paired with my modules.services.nginx module).
#
# Resources
#   https://forgejo.org/docs/latest/
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.forgejo;
in {
  options.modules.services.forgejo = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Allows git@... clone addresses rather than forgejo@...
    users.users.git = {
      useDefaultShell = true;
      home = "/var/lib/forgejo"; # Forgejo data directory
      group = "forgejo";
      isSystemUser = true;
    };
    user.extraGroups = ["forgejo"];

    services.forgejo = {
      enable = true;
      lfs.enable = true;

      user = "git";
      group = "forgejo";

      database = {
        type = "postgres"; # default: sqlite3
        user = "git";
        name = "git";
      };

      settings = {
        # We're assuming SSL-only connectivity
        #session.COOKIE_SECURE = false; # services.forgejo.settings.session.COOKIE_SECURE

        server.DISABLE_ROUTER_LOG = true;
        database.LOG_SQL = false;
        service.ENABLE_BASIC_AUTHENTICATION = false;

        # Only log what's important, but Info is necessary for fail2ban to work
        log.LEVEL = "Info";
      };

      dump.interval = "daily";
    };

    services.fail2ban.jails.forgejo = ''
      enabled = true
      filter = forgejo
      banaction = %(banaction_allports)s
      maxretry = 5
    '';
  };
}
