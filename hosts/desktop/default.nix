{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/bluetooth.nix
    ../../modules/clamav.nix
    ../../modules/cups.nix
    ../../modules/docker.nix
    ../../modules/docker-containers.nix
    ../../modules/firejail.nix
    ../../modules/gamemode.nix
    ../../modules/kde-plasma.nix
    ../../modules/nvidia.nix
    ../../modules/pipewire.nix
    ../../modules/pkgs.nix
    #../../modules/pkgs-gaming.nix
    ../../modules/ssh.nix
    ../../modules/tailscale.nix
    ../../modules/touchpad.nix
    ../../modules/virt-manager.nix
    ../../modules/common
  ];
}
