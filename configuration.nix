# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config = {
    allowUnfree = true;
    firefox = {
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = true;
    };
  };

  nix = {
      package             = pkgs.nixUnstable;
    binaryCaches        = [ http://cache.nixos.org ];
    trustedBinaryCaches = [ http://cache.nixos.org ];
    useChroot           = true;
    gc = {
      automatic = true;
      dates     = "2 weeks";
    };
  };
  
  hardware.pulseaudio.enable = true;
  
  # Use the gummiboot efi boot loader.
  boot = {
    initrd = {
    kernelModules = [
    "ahci"
    "fbcon"
    "i915"
    ]; };
    kernelPackages = pkgs.linuxPackages_4_3;
    kernelParams = [ "audit=0" ];
    extraModprobeConfig = ''
	options hid_apple iso_layout=0
	options hid_apple swap_opt_cmd=1
	'';
    loader.gummiboot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.grub.device = "/dev/sda";
  };

  networking.hostName = "tom-mba"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; with gnome3; [
    wget
    (emacs.override { 
	withGTK2 = false;
	withGTK3 = true; })
    coreutils
    docker
    firefoxWrapper
    bash
    htop
    iotop
    powertop
    gitFull
    kde5.plasma-nm
    maven
    networkmanager_openvpn
    pharo-launcher
    pharo-vm
    python
    offlineimap
    w3m
    dmenu2
    dconf
    networkmanagerapplet  
    geary
    xorg.xmodmap
    stumpwm
    xorg.xf86inputsynaptics    
    nixops
    nix-repl
    which
    unzip
    gcc
    gnumake
    polkit_gnome
  ];
  
  fonts = {
    enableFontDir          = true;
    enableGhostscriptFonts = true;
    fonts = [
       pkgs.corefonts
       pkgs.clearlyU
       pkgs.cm_unicode
       pkgs.dejavu_fonts
       pkgs.freefont_ttf
       pkgs.terminus_font

       pkgs.ttf_bitstream_vera
    ];
  };
  services = {
  # List services that you want to enable:

  dbus.enable = true;
  openssh.enable = true;
  printing.enable = true;
  acpid.enable = true;
#  mba6x_bl.enable = true;
  upower.enable = true;
  tlp.enable = true;

  gnome3 = {
    tracker.enable = true;
    gnome-online-accounts.enable = true;
    };
  };


  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps";
    # touchpad
      multitouch = {
        enable = true;
        buttonsMap = [ 1 3 2 ];
        additionalOptions = ''
          Option "Sensitivity" "1"
          Option "FingerHigh" "5"
          Option "FingerLow" "4"
          Option "IgnoreThumb" "true"
          Option "IgnorePalm" "true"
          Option "TapButton1" "1"
          Option "TapButton2" "3"
          Option "TapButton3" "0"
          Option "TapButton4" "0"
          Option "ClickFinger1" "1"
          Option "ClickFinger2" "3"
          Option "ClickFinger3" "3"
          Option "ButtonMoveEmulate" "true"
          Option "ButtonIntegrated" "true"
          Option "ClickTime" "25"
          Option "BottomEdge" "10"
          Option "SwipeLeftButton" "8"
          Option "SwipeRightButton" "9"
          Option "SwipeUpButton" "0"
          Option "SwipeDownButton" "0"
          Option "ScrollDistance" "75"
          Option "ScrollUpButton" "4"
          Option "ScrollDownButton" "5"
          Option "ThumbSize" "35"
          Option "PalmSize" "55"
          Option "DisableOnThumb" "false"
          Option "DisableOnPalm" "true"
          Option "SwipeDistance" "1000"
          Option "ScrollLeftButton" "7"
          Option "ScrollRightButton" "6"
          Option "AccelerationProfile" "1"
          Option "ConstantDeceleration" "2.0" # Decelerate endspeed
	  Option "AdaptiveDeceleration" "2.0" # Decelerate slow movements
          Option "ScrollSmooth" "true" # Experiment
	'';
	};
  # Enable the KDE Desktop Environment.
  #  displayManager.kdm.enable = true;
  #  desktopManager.kde5.enable = true;

  # Enable the GNOME Desktop Environment.
   # displayManager.gdm.enable = true;
   # desktopManager.gnome3.enable = true;

    displayManager.slim.enable = true;
    desktopManager.xfce.enable = true;


    synaptics = {
      enable = true;
      twoFingerScroll = true;
      palmDetect = true;
    };
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.tspring = {
    isNormalUser = true;
    home = "/home/tspring";
    extraGroups = [ "wheel" "networkManager" "audio"];
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";

}
