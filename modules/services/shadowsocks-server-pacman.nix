## reference
## https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/shadowsocks.nix
{
  config,
  options,
  pkgs,
  lib,
  my,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.shadowsocks-server-pacman;
  opts =
    {
      server = cfg.localAddress;
      server_port = cfg.port;
      method = cfg.encryptionMethod;
      mode = cfg.mode;
      user = "nobody";
      fast_open = cfg.fastOpen;
    }
    // optionalAttrs (cfg.plugin != null) {
      plugin = cfg.plugin;
      plugin_opts = cfg.pluginOpts;
    }
    // optionalAttrs (cfg.password != null) {
      password = cfg.password;
    }
    // cfg.extraConfig;

  configFile = pkgs.writeText "shadowsocks_pacman.json" (builtins.toJSON opts);
in {
  ##### Interfaces
  options.modules.services.shadowsocks-server-pacman = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to run shadowsocks-rust shadowsocks server.
      '';
    };

    localAddress = mkOption {
      type = types.str;
      default = "[::0]"; # "0.0.0.0"
      description = lib.mdDoc ''
        Local addresses to which the server binds.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8388;
      description = lib.mdDoc ''
        Port which the server uses.
      '';
    };

    password = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        Password for connecting clients.
      '';
    };

    passwordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Password file with a password for connecting clients.
      '';
    };

    mode = mkOption {
      type = types.enum ["tcp_only" "tcp_and_udp" "udp_only"];
      default = "tcp_and_udp";
      description = lib.mdDoc ''
        Relay protocols.
      '';
    };

    fastOpen = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        use TCP fast-open
      '';
    };

    encryptionMethod = mkOption {
      type = types.str;
      default = "chacha20-ietf-poly1305";
      description = lib.mdDoc ''
        Encryption method. See <https://github.com/shadowsocks/shadowsocks-org/wiki/AEAD-Ciphers>.
      '';
    };

    plugin = mkOption {
      type = types.nullOr types.str;
      default = "${pkgs.shadowsocks-v2ray-plugin}/bin/v2ray-plugin";
      example = literalExpression ''"''${pkgs.shadowsocks-v2ray-plugin}/bin/v2ray-plugin"'';
      description = lib.mdDoc ''
        SIP003 plugin for shadowsocks
      '';
    };

    pluginOpts = mkOption {
      type = types.str;
      default = "";
      example = "server;host=example.com";
      description = lib.mdDoc ''
        Options to pass to the plugin if one was specified
      '';
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = {};
      example = {
        nameserver = "8.8.8.8";
      };
      description = lib.mdDoc ''
        Additional configuration for shadowsocks that is not covered by the
        provided options. The provided attrset will be serialized to JSON and
        has to contain valid shadowsocks options. Unfortunately most
        additional options are undocumented but it's easy to find out what is
        available by looking into the source code of
        <https://github.com/shadowsocks/shadowsocks-libev/blob/master/src/jconf.c>
      '';
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      shadowsocks-rust
      shadowsocks-v2ray-plugin
    ];

    assertions =
      singleton
      {
        assertion = cfg.password == null || cfg.passwordFile == null;
        message = "Cannot use both password and passwordFile for shadowsocks-rust";
      };

    systemd.services.shadowsocks-rust-server-pacman = {
      description = "shadowsocks-rust server Daemon";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      path = [pkgs.shadowsocks-rust] ++ optional (cfg.plugin != null) cfg.plugin ++ optional (cfg.passwordFile != null) pkgs.jq;
      serviceConfig.PrivateTmp = true;
      script = ''
        ${optionalString (cfg.passwordFile != null) ''
          cat ${configFile} | jq --arg password "$(cat "${cfg.passwordFile}")" '. + { password: $password }' > /tmp/shadowsocks_pacman.json
        ''}
        exec ssservice server -c ${
          if cfg.passwordFile != null
          then "/tmp/shadowsocks_pacman.json"
          else configFile
        }
      '';
    };
  };
}
