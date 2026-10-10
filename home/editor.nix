{ ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
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
        "inherits" = "everforest";
        "ui.background" = { };
      };
    };
  };
}
