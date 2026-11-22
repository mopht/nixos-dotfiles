{ pkgs, ... }:

{
  environment.sessionVariables.QS_ICON_THEME = "Papirus-Dark";
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs.dconf.enable = true;
  security.polkit.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  systemd.oomd.enable = true;

  xdg.portal = {
    enable = true;
    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
    };
  };

  services.gnome.gnome-keyring.enable = true;
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
