{ config, pkgs, inputs, ... }:

{
  programs.caelestia = {
    enable = true;
    cli.enable = true;
    settings = {
        bar.tray.compact = true;
        bar.tray.recolour = true;
        launcher.enabelDangerousActions = true;
        paths.wallpaperDir = "~/Pictures/Wallpapers";
    };
  };
}
