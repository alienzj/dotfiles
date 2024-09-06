let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBajmqos/7vTLAOT9m/qbfHReUWU1TJqDQ3ztl+F2UAX jiezhu@magic_app 20240516";
in {
  "forgejo-at-MagIC-APP-database-secret.age".publicKeys = [key];
  "forgejo-at-MagIC-APP-mailjet-smtp-api.age".publicKeys = [key];
  "forgejo-at-MagIC-APP-mailjet-smtp-secret.age".publicKeys = [key];

  "discourse-at-MagIC-APP-admin-secret.age".publicKeys = [key];
  "discourse-at-MagIC-APP-keybase-secret.age".publicKeys = [key];
  "discourse-at-MagIC-APP-database-secret.age".publicKeys = [key];
  "discourse-at-MagIC-APP-mailjet-smtp-api.age".publicKeys = [key];
  "discourse-at-MagIC-APP-mailjet-smtp-secret.age".publicKeys = [key];
}
