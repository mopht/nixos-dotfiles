{ config, pkgs, inputs, ... }:

{
  programs.fzf.enable = true;
  programs.carapace.enable = true;
  programs.starship.enable = true;
  programs.nushell.enable = true;
  programs.direnv.enable = true;

  programs.eza = {
    enable = true;
    icons = "always";
    extraOptions = [ "--group-directories-first" "-1" ];
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };


  programs.kitty = {
    enable = true;

    settings = {
      confirm_os_window_close = 0;
      background_opacity = 0.45;
      enable_audio_bell = false;
      font_family = "Maple Mono NF CN";
      font_size = 17.0;
      shell = "fish";
      window_margin_width = 21.75;
      cursor_shape = "beam";
      cursor_trail = 1;
      cursor_trail_start_threshold = 0;

      "modify_font cell_height" = "+7px";
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      cat ~/.local/state/caelestia/sequences.txt 2> /dev/null
      set -g fish_greeting ""
    '';
  };
}
