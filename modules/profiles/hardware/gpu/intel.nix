# profiles/hardware/common/gpu/intel/default.nix --- lipstick on a pig
#
# I use NVIDIA cards on all my machines, largely because I'm locked into CUDA
# for work reasons. Fortunately, mine aren't too old and are relatively beefy
# (680gtx, 960gtx, 1080, 1660S, 3080ti) so only a little cludge is needed to get
# them to work well on NixOS.
{
  hey,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  hardware = config.modules.profiles.hardware;
in
  mkIf (any (s: hasPrefix "gpu/intel" s) hardware) (mkMerge [
    {
      services.xserver.videoDrivers = mkDefault ["intel"];
      #services.xserver = {
      #  enable = true;
      #  videoDrivers = ["intel"];
      #  exportConfiguration = true;
      #  xkb.layout = "us";
      #  serverFlagsSection = ''
      #    Option "StandbyTime" "20"
      #    Option "SuspendTime" "30"
      #    Option "OffTime" "45"
      #    Option "BlankTime" "45"
      #  '';
      #};

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          vaapiIntel
          libvdpau-va-gl
          intel-media-driver
        ];
      };

      environment.variables.VDPAU_DRIVER = "va_gl";

      environment = {
        systemPackages = with pkgs; [
          gpustat
          gpu-viewer
        ];
      };

      # Cajole Firefox into video-acceleration (or try).
      modules.desktop.browsers.firefox.settings = {
        "media.ffmpeg.vaapi.enabled" = true;
        "gfx.webrender.enabled" = true;
      };
    }

    #(mkIf (config.modules.desktop.type == "wayland") {
    #  # see NixOS/nixos-hardware#348
    #  # TODO: Try these!
    #  environment.systemPackages = with pkgs; [
    #    libva
    #    # Fixes crashes in Electron-based apps?
    #    # libsForQt5.qt5ct
    #    # libsForQt5.qt5-wayland
    #  ];
    #})
  ])
