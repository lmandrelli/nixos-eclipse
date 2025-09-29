# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-eclipse"; # Define your hostname.
  # networking.wireless.enable = true;  # Disabled because we use NetworkManager
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking with NetworkManager (includes wireless support)
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment with Wayland support.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # Configure GDM to use Wayland by default
  services.xserver.displayManager.gdm.wayland = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.lmandrelli = {
    isNormalUser = true;
    description = "Luca Mandrelli";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" "storage" "docker" "libvirtd" "kvm" ];
    shell = pkgs.zsh;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Note: Main package list is defined later in the file

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # Paramètres kernel pour NVIDIA Wayland
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  
  
  # === CONFIGURATION GRAPHIQUE NVIDIA ===
  # Support NVIDIA avec drivers open-kernel
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Utilisation du driver open-kernel (nouveau driver open-source NVIDIA)
    open = true;

    # Activation du support Wayland pour NVIDIA
    modesetting.enable = true;

    # Support de la gestion d'énergie
    powerManagement.enable = true;
    powerManagement.finegrained = false;

    # Menu des paramètres NVIDIA
    nvidiaSettings = true;

    # Utilisation du driver stable le plus récent
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Support OpenGL/Vulkan nécessaire pour les jeux et applications graphiques
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Support 32-bit pour Steam/Proton
  };

  # === CONFIGURATION PROCESSEUR INTEL ===
  # Microcode Intel pour les mises à jour de sécurité
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"  # Nouvelles commandes nix
        "flakes"       # Système de flakes pour la reproductibilité
      ];
      auto-optimise-store = true; # Optimisation automatique du store

      # Configuration des caches binaires (plus sécurisé en premier)
      substituters = [
        "https://cache.nixos.org/"        # Cache officiel NixOS (plus sécurisé)
        "https://nix-community.cachix.org" # Cache communautaire Nix
      ];
     
      # Clés publiques de confiance pour vérification des signatures
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      # Sécurité: Vérification obligatoire des signatures
      require-sigs = true;
    };

    # Nettoyage automatique des générations anciennes
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  
  # === CONFIGURATION STEAM ET GAMING ===
  # Steam avec support Proton pour les jeux Windows
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true; # Session dédiée gaming
  };

  # Support des jeux 32-bit et des drivers
  programs.gamemode.enable = true; # Optimisations gaming

  # === SERVICES SYSTÈME ===
  # Bluetooth pour les périphériques sans fil
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # SSH pour l'accès distant
  services.openssh.enable = true;
  
  # === CONFIGURATION DOCKER ===
  # Docker pour la conteneurisation
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    # Configuration recommandée pour les performances
    storageDriver = "overlay2";

    # Support rootless Docker (optionnel, plus sécurisé)
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # === CONFIGURATION KVM / LIBVIRT ===
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      ovmf.enable = true;
      swtpm.enable = true;
    };
  };
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # === PACKAGES SYSTÈME ===
  # Packages disponibles pour tous les utilisateurs
  environment.systemPackages = with pkgs; [
    # Outils système essentiels
    wget curl git vim nano
    htop tree file

    # Cache binaire
    cachix

    # Support pour les formats d'archive
    unzip zip p7zip

    # Outils de développement de base
    gcc gnumake cmake

    # Navigateur de secours
    firefox

    # AppImage support
    appimage-run
    
    # === OUTILS GNOME SYSTÈME ===
    gnome-tweaks         # Outil de personnalisation GNOME
    dconf-editor         # Éditeur de configuration dconf
    glib                 # Bibliothèques GLib (nécessaire pour certaines applications)
  ];

  # === SERVICES SPÉCIALISÉS ===
  # Polkit pour l'authentification graphique
  security.polkit.enable = true;

  # Portal pour les applications Flatpak/Snap
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
   };

  # === CONFIGURATION SHELLS ===
  # Zsh comme shell par défaut
  programs.zsh.enable = true;

  # === CONFIGURATION APPIMAGE ===
  # Support natif des AppImages avec binfmt
  programs.appimage = {
    enable = true;
    binfmt = true;  # Permet d'exécuter les AppImages directement
  };

  # === CONFIGURATION SUDO ===
  security.sudo.enable = true;

}
