{ ... }:

{
  programs.hyprland.enable = true;

  services.geoclue2.enable = true;
  services.sunshine = {
    enable = true;
    openFirewall = true;
  };

  # environment.variables = {
  #   XCURSOR_THEME = "Bibata-Modern-Classic";
  #   XCURSOR_SIZE = "24";
  # };

  services.greetd = {
    enable = true;

    settings = {
      initial_session = {
        command = "start-hyprland";
        user = "mopht";
      };

      default_session = {
        command = "start-hyprland";
        user = "mopht";
      };
    };
  };
}
