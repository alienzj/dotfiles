# reference
## https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/web-apps/hedgedoc.nix
## https://wiki.nixos.org/wiki/Hedgedoc
{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.hedgedoc;
in {
  options.modules.services.hedgedoc = {
    enable = mkBoolOpt false; # "activate the hedgeDoc markdown editor service";
    host = mkOption {
      type = with types; nullOr str;
      default = "localhost";
    };
    port = mkOption {
      type = types.port;
      default = 8001;
    };
  };

  config =
    mkIf cfg.enable
    (
      mkMerge [
        {
          services.hedgedoc = {
            enable = true;
            settings = {
              db = {
                username = "hedgedoc";
                database = "hedgedoc";
                dialect = "postgres";
                host = "/run/postgresql";
              };
              #domain = "docs.alienzj.tech"; This is useful if you are trying to run hedgedoc behind a reverse proxy
              host = cfg.host;
              port = cfg.port;
              useSSL = false;
              protocolUseSSL = false;
              allowGravatar = true;
              allowOrigin = [
                "localhost"
                "127.0.0.1"
                cfg.host
              ];
            };
          };

          services.postgresql = {
            ensureDatabases = ["hedgedoc"];
            ensureUsers = [
              {
                name = "hedgedoc";
                ensureDBOwnership = true;
                #ensurePermissions."DATABASE hedgedoc" = "ALL PRIVILEGES";
              }
            ];
          };

          networking.firewall.allowedTCPPorts = [cfg.port];
        }
      ]
    );
}
