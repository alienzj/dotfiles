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

  config = mkIf cfg.enable {
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

        #protocolUseSSL = true;

        allowGravatar = true;
      };
    };

    networking.firewall.allowedTCPPorts = [cfg.port];
  };
}
