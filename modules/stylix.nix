{ pkgs, config, ... }:

{
  stylix = {
    enable = true;
    image = ../wallpaper.jpg;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 32;
    };
  };
}
