{ config, lib, ... }:

{
  modules.services.gitea.enable = true;

  services.gitea = {
    appName = "Gitea at MagIC";

    domain = "localhost";              # services.gitea.settings.server.DOMAIN
    rootUrl = "http://127.0.0.1:3000";  # services.gitea.settings.server.ROOT_URL
    disableRegistration = false;       # services.gitea.settings.service.DISABLE_REGISTRATION

    database = {
      passwordFile = config.age.secrets.gitea-database-secret.path;
    };

    # Enable a timer that runs gitea dump to generate backup-files of the current gitea database and repositories.
    dump = {
      enable = true;
      backupDir = "/backup/gitea";
      type = "tar.gz";
    };

    # Gitea configuration.
    # Refer to <https://docs.gitea.io/en-us/config-cheat-sheet/> for details on supported values
    settings = {
      #server = {
	#PROTOCOL = "http";
	#HTTP_ADDR = "0.0.0.0";
	#HTTP_PORT = 3000;
        #SSH_DOMAIN = "henrik.io";
      #};
      mailer = {
        ENABLED = false;
        #FROM = "noreply@magic-inno.hk";
        #HOST = "smtp.mailgun.org:587";
        #USER = "postmaster@mail.henrik.io";
        #MAILER_TYPE = "smtp";
      };
    };
    #mailerPasswordFile = config.age.secrets.gitea-smtp-secret.path;
  };

  #services.nginx.virtualHosts."git.henrik.io" = {
  #  http2 = true;
  #  forceSSL = true;
  #  enableACME = true;
  #  root = "/srv/www/git.henrik.io";
  #  locations."/".proxyPass = "http://127.0.0.1:3000";
  #};

  systemd.tmpfiles.rules = [
    "z ${config.services.gitea.dump.backupDir} 750 git gitea - -"
    "d ${config.services.gitea.dump.backupDir} 750 git gitea - -"
  ];
}
