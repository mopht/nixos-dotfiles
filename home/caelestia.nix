{ config, pkgs, inputs, ... }:

{
  programs.caelestia = {
    enable = true;
    cli.enable = true;
    settings = {
        bar.tray.compact = true;
        # bar.tray.recolourIcons = true;
        paths.wallpaperDir = "~/Pictures/Wallpapers";
    };
  };
}
