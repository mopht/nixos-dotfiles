{ config, pkgs, inputs, ... }:

{
  programs.caelestia = {
    enable = true;
    cli.enable = true;
    settings = {
      bar.tray.compact = true;
      bar.tray.recolour = true;
      services.useTwelveHourClock = false;
      services.useFahrenheit = false;
      services.weatherLocation = "shanwei";
      launcher.enableDangerousActions = true;
      paths.wallpaperDir = "~/Pictures/Wallpapers";
      # appearance.transparency.enabled = true;
      # appearance.transparency.base = 1.0;
      # appearance.transparency.layers = 0.4;
    };
  };

  services.gammastep = {
    enable = true;

    provider = "geoclue2";

    temperature = {
      day = 6500;
      night = 3500;
    };
  };
}
