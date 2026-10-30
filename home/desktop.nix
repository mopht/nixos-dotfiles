{ ... }:

{

  # programs.noctalia = {
  #   enable = true;
  #
  #   settings = { # This may also be a string or path to a .toml file.
  #     theme = {
  #       mode = "dark";
  #       source = "builtin";
  #       builtin = "Catppuccin";
  #     };
  #
  #     wallpaper = {
  #       enabled = true;
  #       default.path = "/path/to/wallpapers/wallpaper.png";
  #     };
  #   };
  # };

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
      # appearance.transparency.base = 0.45;
      # appearance.transparency.layers = 0.8;
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
