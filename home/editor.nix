{ ... }:

{
  programs.helix = {
    enable = true;

    settings = {
      theme = "mtheme";

      editor = {
        line-number = "relative";
        color-modes = true;
        cursor-shape.insert = "bar";

        indent-guides = {
          render = true;
          character = "│";
        };

        statusline = {
          left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
          # center = [ "version-control" ];
          right = [ "diagnostics" "selections" "position" "file-encoding" "file-type" ];
        };

        file-picker.hidden = false;
      };

      keys.insert = {
        j.k = "normal_mode";
      };

      keys.normal = {
        "C-h" = "jump_view_left";
        "C-l" = "jump_view_right";
        "C-j" = "jump_view_down";
        "C-k" = "jump_view_up";

        K = "hover";
      };
    };

    themes = {
      mtheme = {
        "inherits" = "everforest_dark";
        "ui.background" = { };
        "ui.window" = { bg = "foreground_color"; };
        "ui.statusline" = "foreground_color";
        "ui.statusline.inactive" = "dim_color";
      };
    };
  };
}
