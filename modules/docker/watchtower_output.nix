# Auto-generated using compose2nix v0.3.1.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."watchtower" = {
    image = "containrrr/watchtower";
    environment = {
      "TZ " = " \"Europe/Paris\"";
      "WATCHTOWER_CLEANUP " = " \"true\"";
      "WATCHTOWER_SCHEDULE " = " \"0 0 4 * * *\"";
    };
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=watchtower"
      "--network=watchtower_default"
    ];
  };
  systemd.services."docker-watchtower" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "docker-network-watchtower_default.service"
    ];
    requires = [
      "docker-network-watchtower_default.service"
    ];
    partOf = [
      "docker-compose-watchtower-root.target"
    ];
    wantedBy = [
      "docker-compose-watchtower-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-watchtower_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f watchtower_default";
    };
    script = ''
      docker network inspect watchtower_default || docker network create watchtower_default
    '';
    partOf = [ "docker-compose-watchtower-root.target" ];
    wantedBy = [ "docker-compose-watchtower-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-watchtower-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
