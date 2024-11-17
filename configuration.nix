{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    gh
    nixd
    alejandra
    python311
    gparted
    nerdfonts
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

  # touchpad thing that does nothing
  services.xserver.libinput.enable = true;

  # keymap thing that does nothing
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  networking.hostName = "nixos"; # Define your hostname.
  users.users.adam = {
    isNormalUser = true;
    description = "Adam Duvick";
    extraGroups = ["networkmanager" "wheel"];
  };

  # These lines are needed to help the network run more smoothly
  # Certain websites are abysmally slow without it
  # This portion seems to block captive portals so it may need to be commented out occasionally
  # An alternative to commenting this out for captive portals, is to navigate to
  # http://neversll.com which is non-ssl by design so captive portals can always hijack + redirect
  networking.nameservers = [
    "1.1.1.1 # one.one.one.one"
    "1.0.0.1 # one.one.one.one"
  ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = [
      "1.1.1.1 # one.one.one.one"
      "1.0.0.1 # one.one.one.one"
    ];
    dnsovertls = "true";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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

  # Enable Bluetooh
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
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
