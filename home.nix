# Configuration Home Manager pour lmandrelli
{ config, pkgs, inputs, ... }:

{
  # Imports des modules
  imports = [
    # Aucun module externe pour le moment
  ];
  # === INFORMATIONS UTILISATEUR ===
  home = {
    username = "lmandrelli";
    homeDirectory = "/home/lmandrelli";
    stateVersion = "25.05"; # Version de home-manager (alignée sur NixOS)
  };

  # === PACKAGES UTILISATEUR ===
  # Applications et outils spécifiques à l'utilisateur
  home.packages = with pkgs; [
    # === COMPATIBILITÉ WAYLAND/X11 ===
    xwayland xorg.xhost
    
    xdg-desktop-portal-gtk
    # Num Lock control
    numlockx
    # === POLICES ===
    jetbrains-mono nerd-fonts.jetbrains-mono nerd-fonts.meslo-lg

    # === DÉVELOPPEMENT ===
    # Rust et son écosystème
    rustc cargo rustfmt clippy
    
    # Node.js et outils JavaScript/TypeScript
    nodePackages.npm nodePackages.prettier
    bun # Runtime JavaScript moderne et rapide
    
    # Java Development Kit
    jdk # ou jdk21 selon vos besoins
    
    # Python avec support des environnements virtuels
    python3 python3Packages.virtualenv python3Packages.pip
    uv # Gestionnaire de paquets Python moderne
    
    # === ÉDITEURS ET IDE ===
    # Visual Studio Code - éditeur populaire avec extensions
    vscode # Version standard (pas FHS)
    
    # Zed - éditeur moderne écrit en Rust
    zed-editor

    # Android Studio
    android-studio-full
    android-tools

    opencode
    
    # === TERMINAUX ===
    # Warp - terminal moderne avec IA intégrée
    warp-terminal
    
    # Kitty - terminal rapide avec support GPU
    kitty
    
    # === APPLICATIONS DE COMMUNICATION ===
    # Discord pour la communication gaming/développement
    vesktop
    
    # === MULTIMÉDIA ===
    # Spotify pour la musique en streaming
    spotify
    
    
    # VLC - lecteur multimédia universel
    vlc
    
    # === BUREAUTIQUE ===
    # LibreOffice - suite bureautique complète
    libreoffice
    
    # Obsidian - prise de notes avec liens et graphiques
    obsidian
    
    # === NAVIGATEURS ===
    # Firefox comme navigateur principal (déjà installé système)
    # Chromium comme navigateur secondaire
    chromium
    
    # === OUTILS DE CRÉATION ===
    # Inkscape - création vectorielle
    inkscape
    
    # GIMP - édition d'images bitmap
    gimp
    
    # === SÉCURITÉ ===
    # Bitwarden - gestionnaire de mots de passe
    bitwarden-desktop
    
    # === OUTILS SYSTÈME ET DÉVELOPPEMENT ===
    # Outils pour direnv et nix
    nix-direnv
    
    # Outils Git avancés
    git-lfs gh # GitHub CLI
    
    # === OUTILS DOCKER ===
    # Docker et outils de conteneurisation
    docker-compose     # Orchestration multi-conteneurs
    lazydocker        # Interface TUI pour Docker
    dive              # Analyse des couches d'images Docker
    ctop              # Monitoring des conteneurs en temps réel
    
    # === OUTILS SYSTÈME GNOME ===
    pavucontrol   # Contrôle audio graphique
    brightnessctl # Contrôle de la luminosité
    playerctl     # Contrôle des lecteurs multimédia
    
    # === APPLICATIONS GNOME ===
    gnome-terminal        # Terminal GNOME
    nautilus              # Gestionnaire de fichiers GNOME
    gnome-text-editor     # Éditeur de texte GNOME
    gnome-calculator      # Calculatrice GNOME
    gnome-calendar        # Calendrier GNOME
    gnome-weather         # Météo GNOME
    gnome-clocks          # Horloge GNOME
    gnome-maps            # Cartes GNOME
    gnome-contacts        # Contacts GNOME
    gnome-logs            # Journaux système GNOME
    gnome-system-monitor  # Moniteur système GNOME
    eog                   # Visionneur d'images GNOME
    evince                # Visionneur de documents PDF GNOME
    gnome-screenshot      # Capture d'écran GNOME
    
    # === EXTENSIONS GNOME ===
    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    
    # === APPIMAGE SUPPORT ===
    appimage-run  # Nécessaire pour exécuter les AppImages sur NixOS

    typst
    tinymist

    teams-for-linux
  ];

  # === GESTION DES APPIMAGES ===


  # Création du fichier .desktop pour Cider AppImage
  home.file.".local/share/applications/cider.desktop" = {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Cider
      Comment=Client Apple Music alternatif
      Exec=${config.home.homeDirectory}/.local/bin/appimages/cider.AppImage
      Icon=${config.home.homeDirectory}/.local/share/icons/cider.svg
      Categories=AudioVideo;Audio;Player;
      StartupNotify=true
      StartupWMClass=cider
      MimeType=audio/mpeg;audio/flac;audio/ogg;audio/mp4;
      Keywords=music;audio;player;apple;streaming;
    '';
  };
  
  # S'assurer que le répertoire AppImages existe
  home.file.".local/bin/appimages/.keep".text = "";

  # === CONFIGURATION GIT ===
  programs.git = {
    enable = true;
    userName = "lmandrelli";
    userEmail = "luca.mandrelli@icloud.com"; # Changez par votre email
    
    extraConfig = {
      # Configuration pour une meilleure expérience
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = false;
      
      # Améliore les performances sur les gros repos
      core.preloadindex = true;
      core.fscache = true;
      gc.auto = 256;
    };
    
    # Alias utiles pour Git
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --oneline --graph --decorate --all";
    };

    ignores = [
      # direnv
      ".direnv"
      ".envrc"

      # Linux
      "*~"
      ".fuse_hidden*"
      ".directory" 
      ".Trash-*"
      ".nfs*"

      # VSCode
      ".vscode/*"
      "!.vscode/settings.json"
      "!.vscode/tasks.json"
      "!.vscode/launch.json"
      "!.vscode/extensions.json"
      "!.vscode/*.code-snippets"
      ".history/"
      "*.vsix"
      ".history"
      ".ionide"

      # Nix
      "result"
      "result-*"
      ".direnv/"

      # Zed
      ".zed/"

      # Editor/IDE
      ".idea/"
      "*.swp"
      "*.swo"
      "*~"
      ".*.sw[a-z]"

      "AGENTS.md"
    ];
  };

  # === CONFIGURATION ZSH ===
  programs.zsh = {
    enable = true;
    
    # Configuration de base avec suggestions et coloration syntaxique
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    # Historique amélioré
    history = {
      size = 10000;
      save = 10000;
      extended = true; # Horodatage des commandes
      ignoreDups = true;
      ignoreSpace = true; # Ignore les commandes commençant par un espace
    };
    
    # Variables d'environnement personnalisées
    sessionVariables = {
      EDITOR = "nano"; # Éditeur par défaut
      BROWSER = "firefox"; # Navigateur par défaut
    };
    
    # Alias utiles
    shellAliases = {
      # Raccourcis système
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      
      # Git raccourcis
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      
      # NixOS spécifiques
      nrs = "sudo nixos-rebuild switch --flake .";
      nrt = "sudo nixos-rebuild test --flake .";
      hms = "home-manager switch --flake .";
      
      # GNOME spécifiques
      restart-gnome = "systemctl --user restart gnome-shell";
      logout-gnome = "gnome-session-quit --logout";
      
      # Docker raccourcis
      d = "docker";
      dc = "docker-compose";
      dps = "docker ps";
      dpa = "docker ps -a";
      di = "docker images";
      dl = "docker logs";
      de = "docker exec -it";
      dr = "docker run";
      ds = "docker stop";
      drm = "docker rm";
      drmi = "docker rmi";
      
      # Navigation rapide
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
    
    # Configuration oh-my-zsh pour une expérience enrichie
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell"; # Thème simple et efficace
      plugins = [
        "git"           # Aliases et completion Git
        "sudo"          # Double ESC pour ajouter sudo
        "direnv"        # Support direnv
        "command-not-found" # Suggestions de packages
      ];
    };
  };

  # === CONFIGURATION SSH ===
  # Pas de programs.ssh pour éviter les problèmes de permissions avec les symlinks

  # === CONFIGURATION DIRENV ===
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true; # Support nix-shell automatique
  };

  

  # === CONFIGURATION GTK (pour GNOME) ===
  gtk = {
    enable = true;
    
    theme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
    
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    
    font = {
      name = "Noto Sans";
      size = 11;
    };
  };

  # === CONFIGURATION GNOME (dconf) ===
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      show-battery-percentage = true;
    };
    
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 4;
    };
    
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      natural-scroll = true;
      two-finger-scrolling-enabled = true;
    };
    
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };
    
    "org/gnome/shell/extensions/user-theme" = {
      name = "Adwaita-dark";
    };
    
    "org/gnome/desktop/screensaver" = {
      lock-enabled = true;
      lock-delay = "uint32 300";
    };
  };

  # === CONFIGURATION XDG ===
  xdg = {
    enable = true;
    
    # Associations de fichiers par défaut
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
        "application/pdf" = "firefox.desktop";
        "image/jpeg" = "org.gnome.eog.desktop";
        "image/png" = "org.gnome.eog.desktop";
      };
    };
    
    # Dossiers utilisateur standardisés
    userDirs = {
      enable = true;
      createDirectories = true;
      
      desktop = "${config.home.homeDirectory}/Bureau";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Téléchargements";
      music = "${config.home.homeDirectory}/Musique";
      pictures = "${config.home.homeDirectory}/Images";
      videos = "${config.home.homeDirectory}/Vidéos";
      templates = "${config.home.homeDirectory}/Modèles";
      publicShare = "${config.home.homeDirectory}/Public";
    };
  };

  # Permet à Home Manager de gérer lui-même ses services
  programs.home-manager.enable = true;

  

  # === GESTION SÉCURISÉE DU TOKEN GITHUB ===
  # Script pour créer le fichier d'environnement avec le token GitHub
  home.file.".config/claude/github-token.sh" = {
    text = ''
      #!/bin/bash
      # Script de configuration du token GitHub pour Claude Code MCP
      # Usage: ./github-token.sh <your-github-token>
      
      if [ -z "$1" ]; then
        echo "Usage: $0 <github-personal-access-token>"
        echo "Créez un token avec les permissions: repo, read:packages"
        exit 1
      fi
      
      TOKEN_FILE="$HOME/.config/claude/.env"
      echo "GITHUB_TOKEN=$1" > "$TOKEN_FILE"
      chmod 600 "$TOKEN_FILE"
      echo "Token GitHub configuré dans $TOKEN_FILE"
      echo "Permissions du fichier: $(ls -la "$TOKEN_FILE")"
    '';
    executable = true;
  };

  # Variables d'environnement pour Claude Code
  home.sessionVariables = {
    # Assurer que les chemins Nix sont disponibles pour MCP
    MCP_PATH = "${config.home.homeDirectory}/.config/claude";
  };

  # === CONFIGURATION HOME-MANAGER ===
  # Suppression automatique des fichiers de sauvegarde existants et correction permissions SSH
  home.activation = {
    removeExistingBackups = config.lib.dag.entryBefore ["checkLinkTargets"] ''
      run rm -f ~/.gtkrc-2.0.hm-backup
      run rm -f ~/.bashrc.hm-backup
      run rm -f ~/.profile.hm-backup
      run rm -f ~/.zshrc.hm-backup
      run rm -f ~/.gitconfig.hm-backup
      run rm -f ~/.ssh/config.hm-backup
    '';
    
    # Fix SSH config permissions for VSCode - copy file instead of symlink
    copySshConfig = let
      sshConfigFile = pkgs.writeText "ssh-config" ''
        # Configuration SSH pour VSCode et git
        Host *
          PasswordAuthentication no
          ChallengeResponseAuthentication no
          HashKnownHosts yes
          VisualHostKey yes
          Compression yes
          ServerAliveInterval 60
          ServerAliveCountMax 3
      '';
    in config.lib.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p ~/.ssh
      run chmod 700 ~/.ssh
      $DRY_RUN_CMD install -m600 -D ${sshConfigFile} $HOME/.ssh/config
    '';
  };
}
