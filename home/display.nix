{ config, pkgs, inputs, ... }:

{
  qt.enable = true;
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
    };
  };
}
