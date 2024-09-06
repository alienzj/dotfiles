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
      services.xserver = {
        enable = true;
        videoDrivers = mkDefault ["intel"];
        #dpi = 168; # enable hidpi module
        exportConfiguration = true;
        xkb.layout = "us";
        #serverFlagsSection = ''
        #  Option "StandbyTime" "20"
        #  Option "SuspendTime" "30"
        #  Option "OffTime" "45"
        #  Option "BlankTime" "45"
        #'';
      };

      hardware.opengl = {
        enable = true;
        extraPackages = with pkgs; [
          vaapiIntel
          libvdpau-va-gl
          intel-media-driver

          # your Open GL, Vulkan and VAAPI drivers
          vpl-gpu-rt # for newer GPUs on NixOS >24.05 or unstable
          # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
          # intel-media-sdk   # for older GPUs
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
