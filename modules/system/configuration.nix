{
  config,
  pkgs,
  lib,
  ...
}: {
  services.displayManager.sddm.enable = true;
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # TODO remove once we can fully configure hyprland through home-manager, but this is not possible with sddm as the login manager
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    wofi
    waybar
    google-chrome
    font-awesome
    dunst
    eww
    obsidian
    neovim
    git
    wget
    gh
    nixd
    alejandra
    python311
    gparted
    neofetch
    pandoc
    rustup
    rustc
    rustfmt
    gcc
    alsa-lib
    alsa-utils
    alsa-tools
    alsa-oss
    linux-firmware
    podman-compose
  ];

  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  # TODO get a keyring working, running and automatically unlocked on login
  services.gnome.gnome-keyring.enable = true;
  programs.nm-applet.enable = true;
  security.polkit.enable = true;

  # touchpad thing that does nothing
  services.libinput.enable = true;
  services.touchegg.enable = true;

  # keymap thing that does nothing
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adam = {
    isNormalUser = true;
    description = "Adam Duvick";
    extraGroups = ["networkmanager" "wheel"];
  };

  networking = {
    # hostName = "nixos";

    # Configure DNS servers manually
    nameservers = [
      "1.1.1.1" # Cloudflare
      "1.0.0.1" # Cloudflare
      "8.8.8.8" # Google
      "8.8.4.4" # Google
    ];

    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };

    # These options are unnecessary when managing DNS ourselves
    # useDHCP = false;
    # dhcpcd.enable = false;
  };
  # Enable systemd.resolved for DNS management
  services.resolved = {
    enable = true;

    # Disable NetworkManager's internal DNS resolution
    # networkmanager.dns = "none";
    dnssec = "true";
    domains = ["~."];
    fallbackDns = [
      "1.1.1.1" # Cloudflare
      "1.0.0.1" # Cloudflare
      "8.8.8.8" # Google
      "8.8.4.4" # Google
    ];

    # This line seems to be responsible for making captive portals not work
    # comment this line, rebuild, then visit http://neverssl.com
    dnsovertls = "true";
  };

  # Nix settings, auto cleanup and enable flakes
  nix = {
    settings = {
      auto-optimise-store = true;
      allowed-users = ["adam"];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerSocket.enable = true;
      autoPrune.enable = true;
    };
  };

  # Boot settings: clean /tmp/, latest kernel and enable bootloader
  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
      # reducing to 0 effectively means that I will not be able to
      # boot into anything other than the latest
      timeout = 0;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
