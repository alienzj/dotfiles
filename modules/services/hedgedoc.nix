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
              host = cfg.host;
              port = cfg.port;

              ## This is useful if you are trying to run hedgedoc behind a reverse proxy
              #domain = "docs.alienzj.tech";
              ## This is useful if you are trying to run hedgedoc behind a reverse proxy.
              ## Only applied if {option}`domain` is set.
              #protocolUseSSL = true;
              #useSSL = false;

              allowGravatar = true;
              allowOrigin = [
                "localhost"
                "127.0.0.1"
                cfg.host
              ];

              db = {
                username = "hedgedoc";
                database = "hedgedoc";
                dialect = "postgres";
                host = "/run/postgresql";
              };
            };

            #environmentFile = "";
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
