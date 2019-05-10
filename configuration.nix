# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Note sysctl keys must be strings.
  boot.kernel.sysctl."vm_swappiness" = 1;
  boot.kernelPatches = [ {
    name = "elan-pointer";
    patch = null;
    extraConfig = ''
      MOUSE_ELAN_I2C_SMBUS y
    '';
  } ];
  boot.cleanTmpDir = true;

  networking.hostName = "wowbagger"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = false;
  };

  time.timeZone = "Australia/Sydney";

  nix.useSandbox = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Core
    coreutils
    cryptsetup
    file
    fortune
    git
    links
    lshw
    lsof
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
    gnome3.zenity
    gnomeExtensions.caffeine
    gnomeExtensions.nohotcorner

    # Games
    brogue
    crawlTiles
    dosbox
    hyperrogue
    nethack
    openrct2
    steam
    steam-run-native
    wesnoth

    # Music
    abcde
    cmus
    easytag
    ffmpeg
    filezilla
    flac
    lame
    mediainfo
    mplayer
    vorbisTools

    # Devel
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
    fractal
    hexchat
    skype
    slack-dark

    # Photography
    rapid-photo-downloader
    shotwell

    # Misc apps
    bibletime
    ghostscript
    gimp-with-plugins
    graphicsmagick-imagemagick-compat
    inkscape
    lastpass-cli
    ledger
    libreoffice
    wl-clipboard
  ];

  environment.gnome3.excludePackages = with pkgs.gnome3; [
    evolution
    gnome-photos
  ];

  environment.variables = {
    MOZ_USE_XINPUT2 = "1";
  };

  programs.vim.defaultEditor = true;
  programs.plotinus.enable = true;
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
    extraConfig = ''
      load-module module-switch-on-connect
    '';
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

  security.pam.services = {
    gdm.enableGnomeKeyring = true;
    passwd.enableGnomeKeyring = true;
  };

  users.users.chris = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "camera" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
