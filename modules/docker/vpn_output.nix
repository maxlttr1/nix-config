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
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "Etc/UTC";
    };
    volumes = [
      "/home/maxlttr/Syncthing/docker/.config/deluge/config:/config:rw"
      "/home/maxlttr/Syncthing/movies:/downloads:rw"
    ];
    dependsOn = [
      "vpn_stack-gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:vpn_stack-gluetun"
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
  virtualisation.oci-containers.containers."vpn_stack-gluetun" = {
    image = "qmcgaw/gluetun";
    environment = {
      "VPN_SERVICE_PROVIDER" = "custom";
      "VPN_TYPE" = "wireguard";
      "WIREGUARD_ADDRESSES" = config.sops.templates."vpn/WIREGUARD_ADDRESSES".content;
      "WIREGUARD_ENDPOINT_IP" = config.sops.templates."vpn/WIREGUARD_ENDPOINT_IP".content;
      "WIREGUARD_ENDPOINT_PORT" = config.sops.templates."vpn/WIREGUARD_ENDPOINT_PORT".content;
      "WIREGUARD_PRESHARED_KEY" = config.sops.templates."vpn/WIREGUARD_PRESHARED_KEY".content;
      "WIREGUARD_PRIVATE_KEY" = config.sops.templates."vpn/WIREGUARD_PRIVATE_KEY".content;
      "WIREGUARD_PUBLIC_KEY" = config.sops.templates."vpn/WIREGUARD_PUBLIC_KEY".content;
    };
    ports = [
      "8112:8112/tcp"
      "6881:6881/tcp"
      "6881:6881/udp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--device=/dev/net/tun:/dev/net/tun:rwm"
      "--network-alias=gluetun"
      "--network=vpn_stack_default"
    ];
  };
  systemd.services."docker-vpn_stack-gluetun" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-vpn_stack_default.service"
    ];
    requires = [
      "docker-network-vpn_stack_default.service"
    ];
    partOf = [
      "docker-compose-vpn_stack-root.target"
    ];
    wantedBy = [
      "docker-compose-vpn_stack-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-vpn_stack_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f vpn_stack_default";
    };
    script = ''
      docker network inspect vpn_stack_default || docker network create vpn_stack_default
    '';
    partOf = [ "docker-compose-vpn_stack-root.target" ];
    wantedBy = [ "docker-compose-vpn_stack-root.target" ];
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
