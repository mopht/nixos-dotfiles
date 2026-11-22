{ pkgs, ... }:

{
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  qt = {
    enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "Source Han Sans SC"
      "Noto Sans CJK SC"
    ];
    serif = [ "Noto Serif" ];
    monospace = [
      "Maple Mono NF CN"
      "Cascadia Code"
    ];
    emoji = [ "Noto Color Emoji" ];
  };

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Classic";
    size = 24;
    package = pkgs.bibata-cursors;
    gtk.enable = true;
    x11.enable = true;
  };
}
