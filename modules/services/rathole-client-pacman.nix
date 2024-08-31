{
  hey,
  lib,
  config,
  options,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.services.rathole-client-pacman;
  configFile = cfg.configFile;
in {
  options.modules.services.rathole-client-pacman = {
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
    systemd.services.rathole-c-pacman = {
      description = "rathole client Daemon";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      path = [pkgs.unstable.rathole];
      serviceConfig.PrivateTmp = true;
      script = ''
        exec rathole -c ${configFile}
      '';
    };
  };
}
