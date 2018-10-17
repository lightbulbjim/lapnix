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

  boot.kernel.sysctl = {
    "vm.swappiness" = 1;
  };

  networking.hostName = "wowbagger"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "Australia/Sydney";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;
  environment.systemPackages = with pkgs; [
    # Core
    coreutils
    file
    git
    links
    lsof
    screen
    tree
    vim
    wget

    # Laptop
    tlp

    # Gnome
#    gnomeExtensions.no-title-bar
#    numix-gtk-theme

    # Games
    crawlTiles
    dosbox
    nethack
    steam
    steam-run-native
    wesnoth

    # Music
    abcde
    cmus
    easytag
    filezilla

    # Devel
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
    lastpass-cli
    ledger
    libreoffice
  ];

  fonts.fonts = with pkgs; [
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

  # Needed for Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  programs.vim.defaultEditor = true;

  services.printing.enable = true;
  services.tlp.enable = true;
  services.xserver = {
    enable = true;
#    displayManager.gdm.enable = true;
#    desktopManager.gnome3.enable = true;
    desktopManager.xfce.enable = true;
    xkbOptions = "caps:backspace";
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
