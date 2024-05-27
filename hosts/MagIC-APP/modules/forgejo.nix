{ config, lib, ... }:

{
  modules.services.forgejo.enable = true;

  services.forgejo = {
    database = {
      passwordFile = config.age.secrets.forgejo-at-MagIC-APP-database-secret.path;
    };

    # Enable a timer that runs gitea dump to generate backup-files of the current gitea database and repositories.
    dump = {
      enable = true;
      backupDir = "/backup/forgejo";
      type = "tar.gz";
    };

    # Gitea configuration.
    # Refer to <https://docs.gitea.io/en-us/config-cheat-sheet/> for details on supported values
    settings = {
      DEFAULT.APP_NAME = "Forgejo at MagIC";

      server = {
        DOMAIN = "localhost";
        SSH_DOMAIN = "10.132.2.151";
	ROOT_URL = "http://10.132.2.151:3000";
	DISABLE_REGISTRATION = false;
      };
      mailer = {
        ENABLED = true;
        PROTOCOL = "smtp"; # SMTP over TLS
        SMTP_ADDR = "in-v3.mailjet.com";
        SMTP_PORT = "587";
        #FROM = "postmaster@magic-inno.hk"; # didn't work
        FROM = "jiezhu@magic-inno.hk"; # didn't work
        USER = "4c61ab3f9e649680c30769a2a9877f27";
        #USER = config.age.secrets.forgejo-at-MagIC-APP-mailjet-smtp-api.path;
      };
    };
    mailerPasswordFile = config.age.secrets.forgejo-at-MagIC-APP-mailjet-smtp-secret.path;
  };

  age.secrets.forgejo-at-MagIC-APP-mailjet-smtp-api = {
    #file = ../secrets/forgejo-at-MagIC-APP-mailjet-smtp-api.age;
    mode = "400";
    owner = "git";
    group = "forgejo";
  };
  age.secrets.forgejo-at-MagIC-APP-mailjet-smtp-secret = {
    #file = ../secrets/forgejo-at-MagIC-APP-mailjet-smtp-secret.age;
    mode = "400";
    owner = "git";
    group = "forgejo";
  };
  age.secrets.forgejo-at-MagIC-APP-database-secret = {
    #file = ../secrets/forgejo-at-MagIC-APP-database-secret.age;
    mode = "400";
    owner = "git";
    group = "forgejo";
  };

  #services.nginx.virtualHosts."git.magic-inno.hk" = {
  #  http2 = true;
  #  forceSSL = true;
  #  enableACME = true;
  #  root = "/srv/www/git.magic-inno.hk";
  #  locations."/".proxyPass = "http://127.0.0.1:3000";
  #};

  systemd.tmpfiles.rules = [
    "z ${config.services.forgejo.dump.backupDir} 750 git forgejo - -"
    "d ${config.services.forgejo.dump.backupDir} 750 git forgejo - -"
  ];

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
