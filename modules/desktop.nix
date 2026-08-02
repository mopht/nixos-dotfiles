{ ... }:

{
  programs.hyprland.enable = true;

  services.geoclue2.enable = true;
  services.sunshine = {
    enable = true;
    openFirewall = true;
  };

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
