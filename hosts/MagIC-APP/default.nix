# MagIC-APP -- MagIC APP server

{ config, lib, pkgs, ... }:

with lib.my;
{
  imports = [
    ../server.nix
    ../home.nix
    ./hardware-configuration.nix

    # TODO
    #./modules/wireguard.nix
    #./modules/dyndns.nix

    # Services
    #./modules/backup.nix
    #./modules/gitea.nix
    ./modules/forgejo.nix
    ./modules/discourse.nix
    #./modules/cgit.nix
    #./modules/vaultwarden.nix
    #./modules/shlink.nix
    #./modules/metrics.nix
  ];

  ## Modules
  modules = {
    #science = {
    #  ai.enable = true;
    #};
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
      #r.enable = true;
      #julia.enable = true;
      #go.enable = true;
      #conda.enable = true;
      #mamba.enable = true;
      #ruby.enable = true;
      web.enable = true;
    };
    editors = {
      default = "nvim";
      emacs = rec {
        enable = true;
	doom = {
          enable = false;
	  forgeUrl = "https://github.com";
	  repoUrl = "https://github.com/doomemacs/doomemacs";
	  configRepoUrl = "https://github.com/alienzj/doom.d";
	};
      };
      vim.enable = true;
    };
    shell = {
      #vaultwarden.enable = true;
      direnv.enable = true;
      git.enable    = true;
      gnupg.enable  = true;
      tmux.enable   = true;
      zsh.enable    = true;
      fish.enable   = true;
    };
    services = {
      fail2ban.enable = true;
      ssh.enable = true;
      nginx.enable = true;
      docker.enable = true;
      #earlyoom.enable = true;
      #stalwart-mail.enable = true;
    };
    utils = {
      htop.enable = true;
      neofetch.enable = true;
      pandoc.enable = true;
      ghostscript.enable = true;
      disk.enable = true;
    };
  };

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  ## Local config
  time.timeZone = "Asia/Hong_Kong";
  
  ## Security
  #security.acme.defaults.email = "alienchuj@gmail.com";
}
