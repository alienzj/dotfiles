{
  hey,
  lib,
  config,
  options,
  inputs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.services.proxmox-ve;
in {
  options.modules.services.proxmox-ve = {
    enable = mkBoolOpt false;
  };

  imports = [inputs.proxmox-nixos.nixosModules.proxmox-ve];

  config = mkIf cfg.enable {
    services.proxmox-ve = {
      enable = true;
    };

    nixpkgs.overlays = [inputs.proxmox-nixos.overlays.x86_64-linux];
  };
}
