{
  description = "Configuration NixOS avec Home Manager et Flakes";

  inputs = {
    # Canal principal NixOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Canal stable pour packages spécifiques
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    
    # Canal master pour les derniers packages
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    
    # Canal dédié pour Android Studio (pinned to current flake.lock version)
    channel_android_studio.url = "github:NixOS/nixpkgs/c9b6fb798541223bbb396d287d16f43520250518";
    
    # Home Manager pour la gestion des configurations utilisateur
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Support matériel spécialisé
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    
    
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixpkgs-master, channel_android_studio, home-manager, nixos-hardware, ... }@inputs: {
    nixosConfigurations = {
      # Remplacez "nixos" par le nom de votre machine si différent
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          # Overlay pour rendre les packages stable, master et android studio disponibles
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = [
              (final: prev: {
                stable = import nixpkgs-stable {
                  system = prev.system;
                  config.allowUnfree = true;
                };
                master = import nixpkgs-master {
                  system = prev.system;
                  config.allowUnfree = true;
                };
                android-studio-channel = import channel_android_studio {
                  system = prev.system;
                  config.allowUnfree = true;
                  config.android_sdk.accept_license = true;
                };
              })
            ];
          })
          # Configuration matérielle générée automatiquement
          ./hardware-configuration.nix
          # Notre configuration principale
          ./configuration.nix
          
          # Intégration de Home Manager comme module NixOS
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.lmandrelli = import ./home.nix;

	    # CORRECTION: Activation du système de sauvegarde automatique
            # Ceci permet à Home Manager de sauvegarder les fichiers existants
            # avant de les remplacer par sa propre configuration
            home-manager.backupFileExtension = "hm-backup";
            
            # Allow unfree packages in home-manager
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
    };
  };
}
