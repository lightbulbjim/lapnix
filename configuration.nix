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

  networking.hostName = "wowbagger"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Sydney";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Core
    git
    links
    lsof
    screen
    tree
    vim
    wget

    # Gnome
    gnomeExtensions.no-title-bar
    numix-gtk-theme

    # Games
    crawlTiles
    nethack

    # Music
    abcde
    cmus
    easytag

    # Devel
    ruby
    vscode

    # Misc apps
    firefox
    lastpass-cli
    ledger
    qutebrowser
  ];

  programs.vim.defaultEditor = true;

  # networking.firewall.enable = true;
  # services.printing.enable = true;
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;
    xkbOptions = "caps:backspace";
  };

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
