{ config, options, pkgs, lib, my, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.services.rathole-client-awsman;
  configFile = cfg.configFile;
in
{
  options.modules.services.rathole-client-awsman = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to run rathole client.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Rathole client config toml file.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.rathole-client-awsman = {
      description = "rathole client Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.rathole ];
      serviceConfig.PrivateTmp = true;
      script = ''
        exec rathole -c ${configFile}
      '';
    };
  };
}
