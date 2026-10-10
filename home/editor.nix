{ ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "mtheme";
      editor = {
        line-number = "relative";
        cursor-shape.insert = "bar";
      };
      keys.insert = {
        j.k = "normal_mode";
      };
    };

    themes = {
      mtheme = {
        "inherits" = "everforest_dark";
        "ui.background" = { };
        "ui.statusline" = "foreground_color";
        "ui.statusline.inactive" = "dim_color";
      };
    };
  };
}
