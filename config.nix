{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest; # base linux kernel. no zen

  networking.hostName = "nixfromhell"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  hardware.graphics = {
		enable = true;
	};
  	# Load nvidia driver for Xorg and Wayland. Or change all this to the AMD version of it instead. I use nvidia
  	services.xserver.videoDrivers = ["nvidia"];
	hardware.nvidia = {
		open = true;
		modesetting.enable = true;
		powerManagement.enable = true;
		nvidiaSettings = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};
  hardware.cpu.intel.updateMicrocode = true;

  # Set your time zone.
   time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
   console = {
  #   font = "Lat2-Terminus16";
     #keyMap = "us";
     useXkbConfig = true; # use xkb.options in tty.
   };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.sddm.enable = true; # mismatching once again lmao

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
   services.pulseaudio.enable = false;
   services.pipewire = {
     enable = true;
     pulse.enable = true;
   };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.acidpipe = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [

     ];
   };

  # programs.firefox.enable = true;
  services.flatpak.enable = false; #no flatpaks as part of the challenge
  programs.appimage = {
  enable = true;
  binfmt = false;
  }; #appimages are allowed because they're jank on nixos


  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   environment.systemPackages = with pkgs; [
    git
    emacs
    pkgs.mc
    wget
    qutebrowser
    umu-launcher
    foot
    pkgs.cosmic-player # cosmic package in GNOME. comedy!
    haruna
    hyfetch
    jamesdsp
    pkgs.kdePackages.ktorrent # mismatching gnome with kde packages is funny
    pkgs.kdePackages.kjournald
    pkgs.kdePackages.kbreakout #yaaay videogames
    microsoft-edge # evil bloatware
    discord # no custom clients
    wine #no wow64 mode, only normal x86 wine allowed. no winetricks

   ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "25.11";

}
