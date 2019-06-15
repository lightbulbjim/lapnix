# See configuration.nix(5) man page and/or `nixos-help`.

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
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
    coreutils
    cryptsetup
    file
    fortune
    git
    links
    lshw
    lsof
    nix-index
    parallel
    powertop
    screen
    tree
    unzip
    usbutils
    vim
    wget

    # Gnome
    gnome3.cheese
    gnome3.geary
    gnome3.gnome-boxes
    gnome3.gnome-dictionary
    gnome3.zenity
    gnomeExtensions.caffeine
    gnomeExtensions.nohotcorner

    # Games
    brogue
    crawlTiles
    dosbox
    freeciv_gtk
    hyperrogue
    nethack
    openrct2
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
    mpv
    lame
    mediainfo
    vorbisTools
    youtube-dl

    # Devel
    cquery
    flatpak-builder
    gcc
    gnome-builder
    gnumake
    nix-prefetch-github
    nix-prefetch-scripts
    nix-review
    python3
    ruby
    vscode
    zeal

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

    # Chat
    hexchat
    riot-desktop
    skype
    slack-dark

    # Photography
    rapid-photo-downloader
    shotwell

    # Misc apps
    appimage-run
    bibletime
    celestia
    ghostscript
    gimp-with-plugins
    graphicsmagick-imagemagick-compat
    inkscape
    lastpass-cli
    ledger
    libreoffice
    meteo
    tilix
    wl-clipboard
  ];

  environment.gnome3.excludePackages = with pkgs.gnome3; [
    evolution
    gnome-music
    gnome-photos
    gnome-weather
  ];

  environment.shellAliases = {
    mplayer = "mpv";
  };

  environment.variables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  programs.vim.defaultEditor = true;
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
  services.gnome3.gpaste.enable = true;
  services.usbmuxd.enable = true;

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
    xkbOptions = "caps:backspace";
    displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;
  };

  services.tlp = {
    enable = true;
    extraConfig = ''
      CPU_SCALING_GOVERNOR_ON_AC=performance
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
    '';
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
