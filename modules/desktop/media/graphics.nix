# modules/desktop/media/graphics.nix
#
# The hardest part about switching to linux? Sacrificing Adobe. It really is
# difficult to replace and its open source alternatives don't *quite* cut it,
# but enough that I can do a fraction of it on Linux. For the rest I have a
# second computer dedicated to design work (and gaming).
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
  cfg = config.modules.desktop.media.graphics;
in {
  options.modules.desktop.media.graphics = {
    enable = mkBoolOpt false;
    tools.enable = mkBoolOpt true;
    raster.enable = mkBoolOpt true;
    vector.enable = mkBoolOpt true;
    sprites.enable = mkBoolOpt true;
    design.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable;
      (
        optionals cfg.tools.enable
        # CLI/scripting tools
        [
          imagemagick
          # Optimizers
          # LOSSLESS   LOSSY
          optipng
          pngquant
          jpegoptim
          libjpeg # (jpegtran)
          gifsicle
        ]
      )
      ++
      # Replaces Illustrator (maybe indesign?)
      (
        optionals cfg.vector.enable
        [
          inkscape
        ]
      )
      ++
      # Replaces Photoshop
      (
        optionals cfg.raster.enable
        [
          (gimp-with-plugins.override {
            plugins = with gimpPlugins; [
              bimp # batch image manipulation
              # resynthesizer   # content-aware scaling in gimp
              gmic # an assortment of extra filters
            ];
          })
          krita # But Krita is better for digital illustration
        ]
      )
      ++
      # Sprite sheets & animation
      (
        optionals cfg.sprites.enable
        [
          aseprite-unfree
        ]
      )
      ++
      # Replaces Adobe XD (or Sketch)
      (
        optionals cfg.design.enable
        [
          (
            if config.modules.desktop.type == "wayland"
            then
              figma-linux.overrideAttrs (final: prev: {
                postFixup = ''
                  substituteInPlace $out/share/applications/figma-linux.desktop \
                    --replace "Exec=/opt/figma-linux/figma-linux" \
                              "Exec=$out/bin/${final.pname} --enable-features=UseOzonePlatform \
                                                            --ozone-platform=wayland \
                                                            --enable-vulkan \
                                                            --enable-gpu-rasterization \
                                                            --enable-oop-rasterization \
                                                            --enable-gpu-compositing \
                                                            --enable-accelerated-2d-canvas \
                                                            --enable-zero-copy \
                                                            --canvas-oop-rasterization \
                                                            --disable-features=UseChromeOSDirectVideoDecoder \
                                                            --enable-accelerated-video-decode \
                                                            --enable-accelerated-video-encode \
                                                            --enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiIgnoreDriverChecks,RawDraw,Vulkan \
                                                            --enable-hardware-overlays \
                                                            --enable-unsafe-webgpu"
                '';
              })
            else figma-linux
          )
        ]
      );

    home.configFile = mkIf cfg.raster.enable {
      "GIMP/2.10" = {
        source = "${hey.configDir}/gimp";
        recursive = true;
      };
      # TODO Inkscape dotfiles
    };
  };
}
