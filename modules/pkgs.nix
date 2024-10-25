{ pkgs, ... }:

{
  programs.steam.enable = true;

  # Flatpaks
  services.flatpak.packages = [
    "co.logonoff.awakeonlan"
    "com.discordapp.Discord"
    "com.github.tchx84.Flatseal"
    "me.proton.Pass"
  ];

  environment.systemPackages = 
    (with pkgs; [
      kdePackages.alpaka
      bibata-cursors
      bottles
      deja-dup
      kdePackages.filelight
      kdePackages.isoimagewriter
      jetbrains-mono
      kdePackages.kleopatra
      kdePackages.kcolorpicker
      libreoffice-qt-fresh
      librewolf
      mangohud
      papirus-icon-theme
      pciutils
      pods
      protonvpn-gui
      kdePackages.qtwebengine
      syncthingtray
      universal-android-debloater
      ventoy-full
      vscode
      kdePackages.yakuake
    ])
    ++
    (with pkgs.unstable; [
    ]);
 
  services.flatpak = {
    enable = true;
    update = {
      auto = {
        enable = true;
        onCalendar = "daily";
      };
    };
  };
}
