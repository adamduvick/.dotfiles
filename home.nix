{
  config,
  pkgs,
  ...
}: {
  home.username = "adam";
  home.homeDirectory = "/home/adam";
  home.stateVersion = "23.11";

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

  home.packages = [];

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
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
