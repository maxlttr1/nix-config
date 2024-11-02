{
  description = "Coucou";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  }; 
  
  outputs = inputs@{ self, nixpkgs, ... }:
    {
      nixosConfigurations = {
        thinkpad-maxlttr = 
          let
            settings = {
              username = "maxlttr";
              hostname = "thinkpad-maxlttr";
              system = "x86_64-linux";
              kernel = "linuxPackages_hardened";
            };
            /*overlay-unstable = final: prev: {
              unstable = import nixpkgs-unstable {
                system = settings.system;
                config.allowUnfree = true;
              };
            };*/
          in
            nixpkgs.lib.nixosSystem {
              system = settings.system;
              specialArgs = { inherit inputs settings; };
              modules = [
                ./hosts/thinkpad
                #({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
                inputs.disko.nixosModules.disko
                inputs.nix-flatpak.nixosModules.nix-flatpak
                inputs.home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users."${settings.username}" = import ./modules/home.nix;
                  home-manager.sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
                  home-manager.backupFileExtension= "backup";
                }
              ];
            };
        asus-maxlttr = 
          let
            settings = {
              username = "maxlttr";
              hostname = "asus-maxlttr";
              system = "x86_64-linux";
              kernel = "linuxPackages_zen";
            };
            /*overlay-unstable = final: prev: {
              unstable = import nixpkgs-unstable {
                system = settings.system;
                config.allowUnfree = true;
              };
            };*/
          in
            nixpkgs.lib.nixosSystem {
              system = settings.system;
              specialArgs = { inherit inputs settings; };
              modules = [
                ./hosts/asus
                #({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
                inputs.disko.nixosModules.disko
                inputs.nix-flatpak.nixosModules.nix-flatpak
                inputs.home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users."${settings.username}" = import ./modules/home.nix;
                  home-manager.sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
                  home-manager.backupFileExtension= "backup";
                }
              ];
            };
        server-maxlttr = 
          let
            settings = {
              username = "maxlttr";
              hostname = "server-maxlttr";
              system = "x86_64-linux";
              kernel = "linuxPackages_hardened";
            };
            pkgs = nixpkgs.legacyPackages.${settings.system};
          in
            nixpkgs.lib.nixosSystem {
              system = settings.system;
              specialArgs = { inherit inputs settings pkgs; };
              modules = [
                ./hosts/dell-3050
                inputs.disko.nixosModules.disko
              ];
            };
      };
    };
}
