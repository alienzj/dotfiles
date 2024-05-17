let 
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBajmqos/7vTLAOT9m/qbfHReUWU1TJqDQ3ztl+F2UAX jiezhu@magic_app 20240516";
in
{
  "gitea-smtp-secret.age".publicKeys = [ key ];
  "gitea-smtp-username.age".publicKeys = [ key ];
}
