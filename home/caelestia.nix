{ config, pkgs, inputs, ... }:

{
  programs.caelestia = {
    enable = true;
    cli.enable = true;
    settings = {
        bar.tray.compact = true;
        bar.tray.recolour = true;
        services.useTwelveHourClock = false;
        launcher.enableDangerousActions = true;
        paths.wallpaperDir = "~/Pictures/Wallpapers";
    };
  };
}
