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
  virtualisation.oci-containers.containers."nextcloud" = {
    image = "lscr.io/linuxserver/nextcloud:latest";
    environment = {
      "PGID" = "100";
      "PUID" = "1001";
      "TZ" = "Europe/Paris";
    };
    volumes = [
      "/home/maxlttr/Syncthing/docker/.config/nextcloud/config:/config:rw"
      "/home/maxlttr/Syncthing/nextcloud:/data:rw"
    ];
    ports = [
      "8888:443/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=nextcloud"
      "--network=nextcloud_default"
    ];
  };
  systemd.services."docker-nextcloud" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-nextcloud_default.service"
    ];
    requires = [
      "docker-network-nextcloud_default.service"
    ];
    partOf = [
      "docker-compose-nextcloud-root.target"
    ];
    wantedBy = [
      "docker-compose-nextcloud-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-nextcloud_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f nextcloud_default";
    };
    script = ''
      docker network inspect nextcloud_default || docker network create nextcloud_default
    '';
    partOf = [ "docker-compose-nextcloud-root.target" ];
    wantedBy = [ "docker-compose-nextcloud-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-nextcloud-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
