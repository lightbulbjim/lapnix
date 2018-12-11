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

  networking.hostName = "wowbagger"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = false;
  };

  time.timeZone = "Australia/Sydney";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Core
    coreutils
    cryptsetup
    file
    fortune
    git
    links
    lsof
    powertop
    screen
    tree
    usbutils
    vim
    wget

    # Laptop
    tlp

    # Gnome
    gnome3.zenity
    gnomeExtensions.caffeine
    gnomeExtensions.impatience
    gnomeExtensions.no-title-bar
    gnomeExtensions.nohotcorner
    numix-gtk-theme

    # Games
    crawlTiles
    dosbox
    nethack
    openrct2
    steam
    steam-run-native
    wesnoth

    # Music
    abcde
    cmus
    easytag
    filezilla
    flac
    vorbisTools

    # Devel
    gcc
    gnumake
    python3
    ruby
    vscode

    # Ebooks
    calibre
    sigil

    # CAD
    freecad
    kicad
    librecad

    # Browsers
    firefox
    qutebrowser

    # Misc apps
    bibletime
    ghostscript
    gimp-with-plugins
    graphicsmagick-imagemagick-compat
    inkscape
    lastpass-cli
    ledger
    libreoffice
    skype
    thunderbird
  ];

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

  # Needed for Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  programs.vim.defaultEditor = true;

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

#  services.gnome3.evolution-data-server.enable = false;
  environment.gnome3.excludePackages = with pkgs.gnome3; [
    evolution
    evolution-data-server
    gnome-calendar
    gnome-contacts
  ];

  services.xserver = {
    enable = true;
    xkbOptions = "caps:backspace";
    displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;
    desktopManager.gnome3.extraGSettingsOverrides = "
      [org/gnome/desktop/wm/keybindings]
        unmaximize=['<Super>Down', '<Alt>F5', '<Super>j']
        maximize=['<Super>Up', '<Super>k']
        minimize=@as []
        switch-applications=['<Super>Tab', '<Alt>Tab', '<Alt>l', '<Alt>Right']
        switch-applications-backward=['<Shift><Super>Tab', '<Shift><Alt>Tab', '<Alt>h', '<Alt>Left']
        switch-to-workspace-left=['<Control><Alt>Left', '<Control><Alt>h']
        switch-to-workspace-down=['<Super>Page_Down', '<Control><Alt>Down', '<Control><Alt>j']
        switch-to-workspace-up=['<Super>Page_Up', '<Control><Alt>Up', '<Control><Alt>k']
        switch-to-workspace-right=['<Control><Alt>Right', '<Control><Alt>l']
        move-to-workspace-left=['<Control><Shift><Alt>Left', '<Control><Shift><Alt>h']
        move-to-workspace-down=['<Super><Shift>Page_Down', '<Control><Shift><Alt>Down', '<Control><Alt><Shift>j']
        move-to-workspace-up=['<Super><Shift>Page_Up', '<Control><Shift><Alt>Up', '<Control><Shift><Alt>k']
        move-to-workspace-right=['<Control><Shift><Alt>Right', '<Control><Shift><Alt>l']
        move-to-monitor-left=['<Super><Shift>Left', '<Super><Shift>h']
        move-to-monitor-down=['<Super><Shift>Down', '<Super><Shift>j']
        move-to-monitor-up=['<Super><Shift>Up', '<Super><Shift>k']
        move-to-monitor-right=['<Super><Shift>Right', '<Super><Shift>l']
      [org/gnome/mutter/keybindings]
        toggle-tiled-left=['<Super>Left', '<Super>h']
        toggle-tiled-right=['<Super>Right', '<Super>l']
      [org/gnome/settings-daemon/plugins/media-keys]
        screensaver=''
    ";
  };

  services.tlp = {
    enable = true;
    extraConfig = ''
      CPU_SCALING_GOVERNOR_ON_AC=performance
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
    '';
  };

  security.pam.services.gdm.enableGnomeKeyring = true;

  users.users.chris = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
