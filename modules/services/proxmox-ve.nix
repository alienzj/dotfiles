{
  hey,
  lib,
  config,
  options,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.services.proxmox-ve;
in {
  options.modules.services.proxmox-ve = {
    enable = mkBoolOpt false;
  };

  imports = [hey.inputs.proxmox-nixos.nixosModules.proxmox-ve];

  config = mkIf cfg.enable {
    services.proxmox-ve = {
      enable = true;
    };

    nixpkgs.overlays = [hey.inputs.proxmox-nixos.overlays.default];
  };
}
