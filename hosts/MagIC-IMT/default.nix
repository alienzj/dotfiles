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

    # multi users
    ./modules/users.nix
  ];

  # Modules
  modules = {
    science = {
      ds.enable = true;
    };
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
      conda = {
        enable = true;
        installationPath = "~/.conda/envs/env-base";
        extraPkgs = [pkgs.gcc];
      };
      mamba = {
        enable = true;
        mambaRootPrefix = "~/.mamba";
        extraPkgs = [pkgs.gcc];
      };
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
      rstudio-server.enable = true;
      jupyterhub = {
        enable = true;
        adminUser = "alienzj";
        allowedUser = ["alienzj"];
      };
    };
    utils = {
      neofetch.enable = true;
      traceroute.enable = true;
    };
  };

  # Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;
  services.pcscd.enable = true; # for gpg-agent
  services.timesyncd.enable = true; # to sync time

  # Run unpatched dynamic binaries on NixOS
  programs.nix-ld.enable = true;

  ## Security
  #security.acme.defaults.email = "alienchuj@gmail.com";
}
