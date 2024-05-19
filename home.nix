{
  config,
  pkgs,
  ...
}: {
  home.username = "adam";
  home.homeDirectory = "/home/adam";
  home.stateVersion = "23.11";

  home.packages = [];

  home.file = {};

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.bash.enable = true;
  programs.bash.shellAliases = {
    ll = "ls -l";
    ".." = "cd ..";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
