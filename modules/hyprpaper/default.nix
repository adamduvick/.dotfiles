{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.hyprpaper;
in {
  options.modules.hyprpaper = {enable = mkEnableOption "hyprpaper";};
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpaper
    ];

    home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };
}
