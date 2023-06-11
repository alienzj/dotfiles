{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.home-assistant;
in {
  options.modules.services.home-assistant = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    #services.home-assistant = {
    #  enable = true;
    #  config = {
    #    homeassistant = {
    #      name = "Eniac";
    #	   unit_system = "metric";
    #      temperature_unit = "C";
    #	   time_zone = "Asia/Hong_Kong";
    #    };
        #http = {};
	#server_port = 8123;
    #  };
    #};


    # https://nixos.wiki/wiki/Home_Assistant
    virtualisation.oci-containers = {
      backend = "podman";
      containers.homeassistant = {
        volumes = [ "home-assistant:/config" ];
        environment.TZ = "Asia/Hong_Kong";

	# Warning: if the tag does not change, the image will not be updated
        image = "ghcr.io/home-assistant/home-assistant:stable";

        # Example, change this to match your own hardware
        extraOptions = [ 
          "--network=host" 
          "--device=/dev/tty62:/dev/tty63"  # Example, change this to match your own hardware
        ];
      };
    };
  };
}
