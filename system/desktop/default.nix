{ pkgs, ... }:

{
  environment.sessionVariables.QS_ICON_THEME = "Papirus-Dark";
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
    };
  };

  services.geoclue2.enable = true;
  services.sunshine = {
    enable = true;
    autoStart = false;
    openFirewall = true;
  };

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

  imports = [ ./fcitx5.nix ];
}
