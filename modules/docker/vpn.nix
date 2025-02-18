# Auto-generated using compose2nix v0.3.1.
{ pkgs, lib, config, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."deluge" = {
    image = "lscr.io/linuxserver/deluge:latest";
    environment = {
      "PGID" = "100";
      "PUID" = "1001";
      "TZ" = "Etc/UTC";
    };
    volumes = [
      "/home/maxlttr/Syncthing/docker/.config/deluge/config:/config:rw"
      "/home/maxlttr/Syncthing/movies:/downloads:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."docker-deluge" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    partOf = [
      "docker-compose-vpn_stack-root.target"
    ];
    wantedBy = [
      "docker-compose-vpn_stack-root.target"
    ];
  };
  virtualisation.oci-containers.containers."gluetun" = {
    image = "qmcgaw/gluetun";
    environment = {
      "VPN_SERVICE_PROVIDER" = "custom";
      "VPN_TYPE" = "wireguard";
    };
    environmentFiles = [ config.sops.secrets."vpn.env".path ];
    ports = [
      "127.0.0.1:8112:8112/tcp"
      "127.0.0.1:6881:6881/tcp"
      "127.0.0.1:6881:6881/udp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--device=/dev/net/tun:/dev/net/tun:rwm"
      "--network-alias=gluetun"
      "--network=nginx_reverse_proxy_nginx"
    ];
  };
  systemd.services."docker-gluetun" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    partOf = [
      "docker-compose-vpn_stack-root.target"
    ];
    wantedBy = [
      "docker-compose-vpn_stack-root.target"
    ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-vpn_stack-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
