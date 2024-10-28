{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/apparmor.nix
    ../../modules/bluetooth.nix
    ../../modules/cups.nix
    ../../modules/gamemode.nix
    ../../modules/intel.nix
    ../../modules/kde-plasma.nix
    ../../modules/ollama.nix
    ../../modules/pipewire.nix
    ../../modules/pkgs.nix
    ../../modules/pkgs-gaming.nix
    ../../modules/podman.nix
    ../../modules/ssh.nix
    ../../modules/tailscale.nix
    ../../modules/tlp.nix
    ../../modules/touchpad.nix
    ../../modules/virt-manager.nix
    ../../modules/common
  ];
}