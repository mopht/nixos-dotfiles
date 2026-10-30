{ pkgs, ... }:

{
  environment.sessionVariables.QS_ICON_THEME = "Papirus-Dark";
  programs.hyprland.enable = true;
  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.hyprland = {
      default = [ "hyprland" "gtk" ];
      "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
    };
  };
  services.geoclue2.enable = true;
  services.sunshine = {
    enable = true;
    autoStart = false;
    openFirewall = true;
  };

  # environment.variables = {
  #   XCURSOR_THEME = "Bibata-Modern-Classic";
  #   XCURSOR_SIZE = "24";
  # };

  programs.hyprland.withUWSM = true;

  services.greetd = {
    enable = true;

    settings = {
      initial_session = {
        command = "uwsm start hyprland-uwsm.desktop";
        user = "mopht";
      };

      default_session = {
        command = "uwsm start hyprland-uwsm.desktop";
        user = "mopht";
      };
    };
  };
}
