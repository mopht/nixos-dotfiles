{ ... }:

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
