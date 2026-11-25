{ pkgs, ... }:

{
  environment.sessionVariables.QS_ICON_THEME = "Papirus-Dark";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs.dconf.enable = true;
  security.polkit.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  boot.loader.systemd-boot.memtest86.enable = true;
  hardware.enableRedistributableFirmware = true;

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

  services.upower.enable = true;
  services.gnome.gnome-keyring.enable = true;
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
        command = "${pkgs.greetd}/bin/agreety --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

  imports = [ ./fcitx5.nix ];
}
