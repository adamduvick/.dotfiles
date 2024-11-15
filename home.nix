{
  config,
  pkgs,
  ...
}: {
  home.username = "adam";
  home.homeDirectory = "/home/adam";
  home.stateVersion = "23.11";

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  # Enable the podman socket service
  systemd.user.services.podman = {
    Unit = {
      Description = "Podman API Service";
      Documentation = ["man:podman-system-service(1)"];
      StartLimitIntervalSec = 0;
    };
    Service = {
      Type = "exec";
      Environment = ["LOGGING_DRIVER=journald"];
      ExecStart = "${pkgs.podman}/bin/podman system service";
      Restart = "on-failure";
      TimeoutStopSec = 30;
    };
    Install.WantedBy = ["default.target"];
  };

  # Configure XDG for podman socket
  xdg.configFile."containers/containers.conf".text = ''
    [engine]
    events_logger = "file"
    cgroup_manager = "systemd"
    runtime = "crun"
  '';

  # Add environment variables for VS Code integration
  home.sessionVariables = {
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
  };

  home.packages = [
    pkgs.google-chrome
    pkgs.kate
    pkgs.kitty
    pkgs.obsidian
    pkgs.todoist-electron
    pkgs.vscode
    pkgs.neovide
    pkgs.tmux
    pkgs.discord
    pkgs.spotify
    pkgs.thunderbird
    pkgs.whatsapp-for-linux
  ];

  home.file = {};

  programs.bash.enable = true;
  programs.bash.shellAliases = {
    ll = "ls -l";
    ".." = "cd ..";
  };
  # Install VS Code with the Dev Containers extension
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-vscode-remote.remote-containers
      eamodio.gitlens
      bbenoist.nix
      ms-python.python
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Adam Duvick";
    userEmail = "adamduvick@gmail.com";

    # Optional but useful git configurations
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      # Add any other git configurations you want
    };

    # Optional: Configure git aliases
    aliases = {
      st = "status";
      co = "checkout";
      # Add any other aliases you use
    };
  };
}
