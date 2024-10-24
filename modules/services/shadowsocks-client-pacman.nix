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
  cfg = config.modules.services.shadowsocks-client-pacman;
  opts =
    {
      server_port = cfg.remotePort;
      local_address = cfg.localAddress;
      local_port = cfg.localPort;
      method = cfg.encryptionMethod;
      mode = cfg.mode;
      user = "nobody";
      fast_open = cfg.fastOpen;
    }
    // optionalAttrs (cfg.remoteAddress != null) {
      server = cfg.remoteAddress;
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
  options.modules.services.shadowsocks-client-pacman = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to run shadowsocks-rust shadowsocks client.
      '';
    };

    remoteAddress = mkOption {
      type = types.str;
      default = "207.148.125.210";
      description = lib.mdDoc ''
        Remote addresses to which the server run at.
      '';
    };

    remoteAddressFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Remote Server Address file with remote server ip.
      '';
    };

    remotePort = mkOption {
      type = types.port;
      default = 8388;
      description = lib.mdDoc ''
        Port which the server uses.
      '';
    };

    localAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        Local addresses to which the client binds.
      '';
    };

    localPort = mkOption {
      type = types.port;
      default = 1080;
      description = lib.mdDoc ''
        Port which the client uses.
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
      default = "${pkgs.unstable.shadowsocks-v2ray-plugin}/bin/v2ray-plugin";
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
      unstable.shadowsocks-rust
      unstable.shadowsocks-v2ray-plugin
    ];

    assertions =
      singleton
      {
        assertion = cfg.password == null || cfg.passwordFile == null;
        message = "Cannot use both password and passwordFile for shadowsocks-libev";
      };

    systemd.services.shadowsocks-rust-client-pacman = {
      description = "shadowsocks-rust client Daemon";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      path = [pkgs.unstable.shadowsocks-rust] ++ optional (cfg.plugin != null) cfg.plugin ++ optional (cfg.passwordFile != null) pkgs.jq;
      serviceConfig.PrivateTmp = true;
      script = ''
        ${optionalString (cfg.passwordFile != null) ''
          cat ${configFile} | jq --arg password "$(cat "${cfg.passwordFile}")" '. + { password: $password }' > /tmp/shadowsocks_pacman.json
        ''}

        ${optionalString (cfg.remoteAddressFile != null) ''
          jq --arg server "$(cat "${cfg.remoteAddressFile}")" '. + { server: $server }' >> /tmp/shadowsocks_pacman.json
        ''}

        exec ssservice local -c ${
          if cfg.passwordFile != null
          then "/tmp/shadowsocks_pacman.json"
          else configFile
        }
      '';
    };
  };
}
