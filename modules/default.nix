{
  inputs,
  pkgs,
  config,
  ...
}: {
  home.stateVersion = "23.11";
  imports = [
    ./hyprland
    ./hyprpaper
  ];
}