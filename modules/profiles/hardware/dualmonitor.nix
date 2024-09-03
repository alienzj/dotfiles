# dual monitor
{
  hey,
  lib,
  config,
  ...
}:
with lib;
with hey.lib;
  mkIf (elem "dualmonitor" config.modules.profiles.hardware) {
    environment.variables.DUALMONITOR = "yes";
  }
