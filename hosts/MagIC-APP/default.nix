# MagIC-APP -- MagIC APP server
{
  config,
  lib,
  pkgs,
  ...
}:
with lib.my; {
  imports = [
    ../server.nix
    ../home.nix
    ./hardware-configuration.nix

    # Services
    ./modules/forgejo.nix
    ./modules/discourse.nix
  ];

  # Modules
  modules = {
    dev = {
      cc = {
        enable = true;
        xdg.enable = true;
      };
      node = {
        enable = true;
        xdg.enable = true;
      };
      rust = {
        enable = true;
        xdg.enable = true;
      };
      python = {
        enable = true;
        xdg.enable = true;
      };
      shell = {
        enable = true;
        xdg.enable = true;
      };
      web.enable = true;
    };
    editors = {
      default = "nvim";
      vim.enable = true;
      vscode.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      tmux.enable = true;
      zsh.enable = true;
      fish.enable = true;
    };
    services = {
      fail2ban.enable = true;
      ssh.enable = true;
      nginx.enable = true;
      docker.enable = true;
      earlyoom.enable = true;
      hedgedoc = {
        enable = true;
        host = "10.132.2.151";
        port = 8001;
      };
    };
    utils = {
      htop.enable = true;
      neofetch.enable = true;
      pandoc.enable = true;
      ghostscript.enable = true;
      disk.enable = true;
    };
  };

  # Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  # Run unpatched dynamic binaries on NixOS
  programs.nix-ld.enable = true;

  ## Security
  #security.acme.defaults.email = "alienchuj@gmail.com";
}
