{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; {
  imports =
    # I use home-manager to deploy files to $HOME; little else
    [inputs.home-manager.nixosModules.home-manager]
    # All my personal modules
    ++ (mapModulesRec' (toString ./modules) import);

  # Common config for all nixos machines; and to ensure the flake operates
  # soundly
  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix = let
    filteredInputs = filterAttrs (n: _: n != "self") inputs;
    nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
    registryInputs = mapAttrs (_: v: {flake = v;}) filteredInputs;
  in {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    nixPath =
      nixPathInputs
      ++ [
        "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
        "dotfiles=${config.dotfiles.dir}"
      ];
    registry =
      registryInputs
      // {
        dotfiles.flake = inputs.self;
      };
    settings = {
      substituters = ["https://nix-community.cachix.org"];
      trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
      auto-optimise-store = true;
    };
  };
  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "24.11";

  ## Some reasonable, global defaults
  # This is here to appease 'nix flake check' for generic hosts with no
  # hardware-configuration.nix or fileSystem config.
  fileSystems."/".device = mkDefault "/dev/disk/by-label/nixos";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so we enforce
  # this default behavior here.
  networking.useDHCP = mkDefault false;

  # Use the latest kernel

  boot = {
    kernelPackages = mkDefault pkgs.linuxPackages_latest;
    loader = {
      #timeout = 60; # press t when boot
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot = {
        enable = true;
        configurationLimit = 7;
      };
    };
  };

  # Just the bear necessities...
  environment.systemPackages = with pkgs; [
    coreutils-full
    binutils
    bind
    cached-nix-shell
    hydra-check
    git
    vim
    neovim
    wget
    curl
    gnumake
    bc
    ripgrep
    htop
    btop
    bat
    eza
    fd
    fzf
    jq
    tokei
    diskus
    pigz
    unzip
    tldr
    shfmt
  ];

  # Console setup
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
  console.earlySetup = lib.mkDefault true;

  #find "$(nix eval --raw 'nixpkgs#kbd')/share/keymaps" -name '*.map.gz'
  console.keyMap = "us";
}
