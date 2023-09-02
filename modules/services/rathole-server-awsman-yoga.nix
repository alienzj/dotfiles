{ config, options, pkgs, lib, my, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.services.rathole-server-awsman-yoga;
  configFile = cfg.configFile;
in
{
  options.modules.services.rathole-server-awsman-yoga = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to run rathole server.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Rathole server config toml file.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.rathole-s-awsman-yoga = {
      description = "rathole server Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.rathole ];
      serviceConfig.PrivateTmp = true;
      script = ''
        exec rathole -s ${configFile}
      '';
    };
  };
}
