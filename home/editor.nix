{ ... }:

{
  programs.lazygit.enable = true;

  programs.helix = {
    enable = true;

    settings = {
      theme = "mtheme";

      editor = {
        auto-save.focus-lost = true;
        # bufferline = "multiple";
        line-number = "relative";
        color-modes = true;
        cursor-shape.insert = "bar";
        cursor-shape.normal = "block";

        indent-guides = {
          render = true;
          character = "│";
        };

        statusline = {
          left = [ "mode" "spinner" "version-control" "file-name" "file-modification-indicator" ];
          # center = [ ];
          right = [ "diagnostics" "selections" "position" "file-encoding" "file-type" ];
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };

        lsp = {
          display-messages = true;
          display-inlay-hints = false;
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
    languages = {
      language = [
      {
        name = "haskell";
        indent = {
          tab-width = 4;
          unit = "    ";
        };
      }
      ];
    };
  };
}
