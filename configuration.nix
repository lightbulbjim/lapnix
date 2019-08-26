# See configuration.nix(5) man page and/or `nixos-help`.

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./cpu-power.nix
    ];

  # UEFI me
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Note sysctl keys must be strings.
  boot.kernel.sysctl."vm_swappiness" = 1;
  boot.cleanTmpDir = true;

  networking.hostName = "oolon";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = false;
  };

  nix.useSandbox = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Core
    bind
    borgbackup
    coreutils
    cryptsetup
    file
    fortune
    git
    gnupg
    links
    lm_sensors
    lshw
    lsof
    magic-wormhole
    nix-index
    parallel
    powertop
    s-tui
    screen
    stress
    tree
    unzip
    usbutils
    vim
    wget

    # Desktop
    adwaita-qt
    gnome3.gnome-themes-standard
    gnome3.gnome-themes-extra
    gnome3.orca
    gnome3.zenity
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.nohotcorner
    gnomeExtensions.sound-output-device-chooser
    qt4
    qt5.qtwayland
    qt5ct

    # Games
    brogue
    crawlTiles
    dosbox
    gnome3.aisleriot
    hyperrogue
    nethack
    openrct2
    openttd
    steam
    steam-run-native
    wesnoth

    # Multimedia
    abcde
    cmus
    easytag
    ffmpeg
    filezilla
    flac
    handbrake
    mpv
    lame
    lollypop
    mediainfo
    playerctl
    vorbisTools
    youtube-dl

    # Devel
    cquery
    flatpak-builder
    gcc
    gnome3.gitg
    gnome3.glade
    gnome3.gnome-boxes
    gnome-builder
    gnumake
    nix-prefetch-github
    nix-prefetch-scripts
    nix-review
    python3
    ruby
    vscode

    # Ebooks
    calibre
    python27Packages.pycrypto
    sigil

    # CAD
    freecad
    kicad
    librecad

    # Browsers
    firefox
    qutebrowser

    # Chat/Email
    gnome3.cheese
    gnome3.geary
    irccloud
    riot-desktop
    skype
    slack-dark

    # Photography
    gimp
    graphicsmagick-imagemagick-compat
    rapid-photo-downloader
    shotwell

    # Misc apps
    appimage-run
    bibletime
    celestia
    ghostscript
    gnome-latex
    inkscape
    ledger
    libreoffice
    pass
    qtpass
    tilix
    transmission-gtk
    wl-clipboard
    yubikey-manager-qt
    yubikey-personalization-gui
    yubioath-desktop
  ];

  environment.gnome3.excludePackages = with pkgs.gnome3; [
    evolution
    gnome-music
    gnome-photos
  ];

  environment.shellAliases = {
    mplayer = "mpv";
  };

  environment.variables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
    #QT_QPA_PLATFORM = "wayland";
    #QT_WAYLAND_FORCE_DPI = "110";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "0";
  };

  programs.vim.defaultEditor = true;
  programs.gpaste.enable = true;
  programs.gphoto2.enable = true;

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      cm_unicode
      corefonts
      culmus
      dejavu_fonts
      freefont_ttf
      google-fonts
      liberation_ttf
      proggyfonts
      roboto
      terminus_font_ttf
      xorg.fontbhlucidatypewriter75dpi
    ];
  };

  hardware.opengl.driSupport32Bit = true;  # Needed for Steam
  hardware.bluetooth.enable = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;  # Needed for Steam
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  services.flatpak.enable = true;
  services.packagekit.enable = true;
  services.usbmuxd.enable = true;
  services.pcscd.enable = true;  # Needed for Yubikey CCID mode

  services.udev.packages = [
    pkgs.yubikey-personalization
  ];

  services.openssh = {
    enable = false;
    challengeResponseAuthentication = false;
    passwordAuthentication = false;
    permitRootLogin = false;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      brgenml1cupswrapper
      brlaser
      gutenprint
      gutenprintBin
      hplip
    ];
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;
  };

  i18n.consoleUseXkbConfig = true;

  security.pam.services = {
    gdm.enableGnomeKeyring = true;
    passwd.enableGnomeKeyring = true;
  };

  users.users.chris = {
    description = "Chris";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "camera" ];
  };

  # Do not change.
  system.stateVersion = "19.03"; # Did you read the comment?

}
