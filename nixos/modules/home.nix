{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "maxlttr";
  home.homeDirectory = "/home/maxlttr";

  # Packages that should be installed to the user profile.
  home.packages = [
  ];

  programs.plasma = {
    enable = true;
    workspace = {
      clickItemTo = "open"; # If you liked the click-to-open default from plasma 5
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 32;
      };
      iconTheme = "Papirus-Dark";
    };
     panels = [
      # Windows-like panel at the bottom
      {
        location = "bottom";
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "nix-snowflake-white";
                alphaSort = true;
              };
            };
          }
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"
              ];
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.pager"
          "org.kde.plasma.marginsseparator"
          {
            systemMonitor = {
              sensors = {
                {
                name = "cpu/all/usage";
                color = "180,190,254";
                label = "CPU %";
                }
              };
            };
          }
          }
          {
            systemTray.items = {
              # We explicitly show bluetooth and battery
              shown = [
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
                "org.kde.plasma.brightness"
                "org.kde.plasma.battery"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.notifications" 
              ];
              # And explicitly hide networkmanagement and volume
              hidden = [
              ];
            };
          }
          {
            digitalClock = {
              calendar.firstDayOfWeek = "monday";
              time.format = "24h";
            };
          }   
        ];
      }
     ];
  };

  programs.git = {
    enable = true;
    userEmail = "maxime.lettier@protonmail.com";
    userName = "maxlttr1";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
