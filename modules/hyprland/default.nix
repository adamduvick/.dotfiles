{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.hyprland;
in {
  options.modules.hyprland = {enable = mkEnableOption "hyprland";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprland
      hypridle
      hyprpaper
      hyprlock
      hyprpolkitagent
      wlsunset
      wl-clipboard
    ];

    home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;

    home.file.".config/hypr/hypridle.conf".source = ./hypridle.conf;

    home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;

    home.file.".config/hypr/hyprpaper.conf".text = ''
      preload = ${./desktop.png}
      wallpaper = , ${./desktop.png}
    '';

    home.file.".config/waybar/config.jsonc".source = ./waybar/waybar.jsonc;
    home.file.".config/waybar/style.css".source = ./waybar/style.css;
    home.file.".config/waybar/macchiatio.css".source = ./waybar/macchiatio.css;
  };
}
