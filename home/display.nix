{ config, pkgs, inputs, ... }:

{
  qt.enable = true;
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };
}
