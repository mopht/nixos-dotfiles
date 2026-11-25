{ ... }:

{
  programs.caelestia = {
    enable = true;
    cli.enable = true;
    settings = {
      bar.tray.compact = true;
      bar.tray.recolour = true;
      services.clockFormat = "TwentyFourHour";
      services.weatherUnits = "Celsius";
      services.sensorUnits = "Celsius";
      services.weatherLocation = "shanwei";
      launcher.enableDangerousActions = true;
      paths.wallpaperDir = "~/Pictures/Wallpapers";
    };
  };

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 22.79;
    longitude = 115.36;
    temperature = {
      day = 6500;
      night = 3500;
    };
  };
}
