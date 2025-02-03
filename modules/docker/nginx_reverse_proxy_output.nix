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
  virtualisation.oci-containers.containers."nginx_reverse_proxy" = {
    image = "docker.io/jc21/nginx-proxy-manager:latest";
    volumes = [
      "/home/maxlttr/Syncthing/docker/.config/nginx_reverse_proxy/data:/data:rw"
      "/home/maxlttr/Syncthing/docker/.config/nginx_reverse_proxy/letsencrypt:/etc/letsencrypt:rw"
    ];
    ports = [
      "80:80/tcp"
      "81:81/tcp"
      "443:443/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=app"
      "--network=nginx_reverse_proxy_default"
    ];
  };
  systemd.services."docker-nginx_reverse_proxy" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-nginx_reverse_proxy_default.service"
    ];
    requires = [
      "docker-network-nginx_reverse_proxy_default.service"
    ];
    partOf = [
      "docker-compose-nginx_reverse_proxy-root.target"
    ];
    wantedBy = [
      "docker-compose-nginx_reverse_proxy-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-nginx_reverse_proxy_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f nginx_reverse_proxy_default";
    };
    script = ''
      docker network inspect nginx_reverse_proxy_default || docker network create nginx_reverse_proxy_default
    '';
    partOf = [ "docker-compose-nginx_reverse_proxy-root.target" ];
    wantedBy = [ "docker-compose-nginx_reverse_proxy-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-nginx_reverse_proxy-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
