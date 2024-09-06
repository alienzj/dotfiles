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
  mkIf (any (s: hasPrefix "gpu/amd" s) hardware) (mkMerge [
    {
      services.xserver = {
        enable = true;
        videoDrivers = ["amdgpu"];
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

      services.libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          clickMethod = "clickfinger";
          naturalScrolling = true;
        };
      };

      hardware.graphics = {
        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
          # opencl
          rocmPackages.clr.icd
          rocmPackages.clr
          amdvlk
        ];
        extraPackages32 = with pkgs; [
          driversi686Linux.amdvlk
        ];
      };

      environment.variables.AMD_VULKAN_ICD = lib.mkDefault "RADV";

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
