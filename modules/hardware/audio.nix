{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.audio;
in {
  options.modules.hardware.audio = {
    enable = mkBoolOpt false;
  };

  # https://nixos.wiki/wiki/PipeWire
  # read above
  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;
    };

    security.rtkit.enable = true;

    hardware.pulseaudio.enable = false;
    environment.systemPackages = with pkgs; [
      easyeffects
      # helvum
      pavucontrol
      # pulseaudio # for pactl
    ];

    # HACK Prevents ~/.esd_auth files by disabling the esound protocol module
    #      for pulseaudio, which I likely don't need. Is there a better way?
    hardware.pulseaudio.configFile = let
      inherit (pkgs) runCommand pulseaudio;
      paConfigFile =
        runCommand "disablePulseaudioEsoundModule"
        {buildInputs = [pulseaudio];} ''
          mkdir "$out"
          cp ${pulseaudio}/etc/pulse/default.pa "$out/default.pa"
          sed -i -e 's|load-module module-esound-protocol-unix|# ...|' "$out/default.pa"
        '';
    in
      mkIf config.hardware.pulseaudio.enable
      "${paConfigFile}/default.pa";

    user.extraGroups = ["audio"];
  };
}
