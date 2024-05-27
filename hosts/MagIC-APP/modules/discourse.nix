# Discourse configuration
# Reference: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/web-apps/discourse.nix

{ config, lib, ... }:

{
  modules.services.discourse.enable = true;

  services.discourse = {
    hostname = "10.132.2.151";

    admin = {
      email = "alienchuj@gmail.com";
      username = "alienzj";
      #username = "biocore";
      fullName = "Jie Zhu";
      passwordFile = config.age.secrets.discourse-at-MagIC-APP-admin-secret.path;
    };    
     
    plugins = with config.services.discourse.package.plugins; [
      discourse-chat-integration
      discourse-checklist
      discourse-canned-replies
      discourse-github
      discourse-assign
      discourse-spoiler-alert
      discourse-solved
    ];

    database = {
      passwordFile = config.age.secrets.discourse-at-MagIC-APP-database-secret.path;
    };

    mail = {
      notificationEmailAddress = "jiezhu@magic-inno.hk";
      contactEmailAddress = "jiezhu@magic-inno.hk";
      outgoing = {
        serverAddress = "in-v3.mailjet.com";
        port = 587;
        domain = "magic-inno.hk";  # ??
        #username = config.age.secrets.discourse-at-MagIC-APP-mailjet-smtp-api.path;
        username = "4c61ab3f9e649680c30769a2a9877f27";
        passwordFile = config.age.secrets.discourse-at-MagIC-APP-mailjet-smtp-secret.path;
      };
      incoming.enable = false;
    };

    siteSettings = {
      plugins = {
        spoiler_enabled = false;
      };
      required = {
        title = "MagIC Discourse";
        site_description = "Discuss Microbiome Science and Innovation";
      };
      #login = {
      #  enable_github_logins = true;
      #  github_client_id = "a2f6dfe838cb3206ce20";
      #  github_client_secret._secret = /run/keys/discourse_github_client_secret;
      #};
    };

    backendSettings = {
      max_reqs_per_ip_per_minute = 300;
      max_reqs_per_ip_per_10_seconds = 60;
      max_asset_reqs_per_ip_per_10_seconds = 250;
      max_reqs_per_ip_mode = "warn+block";
    };

    secretKeyBaseFile = config.age.secrets.discourse-at-MagIC-APP-keybase-secret.path;
  };

  age.secrets.discourse-at-MagIC-APP-database-secret = {
    mode = "400";
    owner = "discourse";
    group = "discourse";
  };
  age.secrets.discourse-at-MagIC-APP-admin-secret = {
    mode = "400";
    owner = "discourse";
    group = "discourse";
  };
  age.secrets.discourse-at-MagIC-APP-mailjet-smtp-api = {
    mode = "400";
    owner = "discourse";
    group = "discourse";
  };
  age.secrets.discourse-at-MagIC-APP-mailjet-smtp-secret = {
    mode = "400";
    owner = "discourse";
    group = "discourse";
  };
  age.secrets.discourse-at-MagIC-APP-keybase-secret = {
    mode = "400";
    owner = "discourse";
    group = "discourse";
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
