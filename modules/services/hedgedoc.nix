# reference
## https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/web-apps/hedgedoc.nix
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
  port = 3013;
in {
  options.modules.services.hedgedoc = {
    enable = mkBoolOpt false; # "activate the hedgeDoc markdown editor service";
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        services.hedgedoc = {
          enable = true;
          settings = {
            inherit port;
            db = {
              dialect = "postgres";
              host = "/run/postgresql";
            };
            #domain = "docs.alienzj.tech"; This is useful if you are trying to run hedgedoc behind a reverse proxy
            host = "localhost";
            #protocolUseSSL = true;
            allowFreeURL = true;
            allowGravatar = true;
          };
        };
        services.postgresql = {
          ensureDatabases = ["hedgedoc"];
          ensureUsers = [
            {
              name = "hedgedoc";
              ensurePermissions."DATABASE hedgedoc" = "ALL PRIVILEGES";
            }
          ];
        };

        networking.firewall.allowedTCPPorts = [3013];
      }
    ]
  );
}
