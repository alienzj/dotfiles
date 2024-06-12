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
    environmentFile = mkOption {
      type = types.path;
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
              # https://docs.hedgedoc.org/configuration/#hedgedoc-location

              # CMD_HOST
              host = cfg.host;
              # CMD_PORT
              port = cfg.port;

              # CMD_DOMAIN
              #domain = "localhost";
              # CMD_PROTOCOL_USESSL
              # only applied when domain is set
              #protocolUseSSL = true;

              # CMD_URL_ADDPORT
              # set to add port on callback URL (ports 80 or 443 won't be applied)
              # only applied when domain is set
              #urlAddPort = true;

              # CMD_ALLOW_ORIGIN
              #allowOrigin = [
              #  "localhost"
              #];

              # CMD_ALLOW_GRAVATAR
              allowGravatar = true;

              db = {
                username = "hedgedoc";
                database = "hedgedoc";
                dialect = "postgres";
                host = "/run/postgresql";
              };
            };

            environmentFile = cfg.environmentFile;
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

          #services.nginx = {
          #  enable = true;

          # Use recommended settings
          #  recommendedGzipSettings = true;
          #  recommendedOptimisation = true;
          #  recommendedProxySettings = true;
          #  recommendedTlsSettings = true;

          #  # Only allow PFS-enabled ciphers with AES256
          #  sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

          #  virtualHosts."hedgedoc.example.com" = {
          #    forceSSL = true;
          #    enableACME = true;
          #    root = "/var/www/hedgedoc";
          #    locations."/".proxyPass = "http://10.132.2.151:8001";
          #    locations."/socket.io/" = {
          #      proxyPass = "http://10.132.2.151:8001";
          #      proxyWebsockets = true;
          #      extraConfig = "proxy_ssl_server_name on;";
          #    };
          #  };
          #};

          networking.firewall.allowedTCPPorts = [cfg.port];
        }
      ]
    );
}
