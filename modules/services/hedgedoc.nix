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
in {
  options.modules.services.hedgedoc = {
    enable = mkBoolOpt false; # "activate the hedgeDoc markdown editor service";
    nginx.enable = mkBoolOpt false; # "activate nginx";
    nginx.subdomain = mkOption {
      type = types.str;
    };
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
            port = 3013;
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

      (mkIf cfg.nginx.enable (mkSubdomain cfg.nginx.subdomain port))

      (mkIf cfg.nginx.enable (mkVPNSubdomain cfg.nginx.subdomain port))
    ]
  );
}
