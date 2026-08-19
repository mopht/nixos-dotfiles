{ ... }:

{
  programs.fzf.enable = true;
  programs.fish.enable = true;
  programs.carapace.enable = true;
  programs.starship.enable = true;
  programs.direnv.enable = true;

  programs.eza = {
    enable = true;
    icons = "always";
    extraOptions = [ "--group-directories-first" "-1" ];
  };

  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false; completions.external.enable = true; completions.external.max_results = 100;
    };
    extraConfig = ''
      open --raw ~/.local/state/caelestia/sequences.txt | print -n
      let commands_completed_by_fish = [nu git niri tailscale]

      let fish_completer = {|spans|
          fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
          | from tsv --flexible --noheaders --no-infer
          | rename value description
          | update value {|row|
            let value = $row.value
            let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
            if ($need_quote and ($value | path exists)) {
              let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
              $'"($expanded_path | str replace --all "\"" "\\\"")"'
            } else {$value}
          }
      }

      $env.config.completions.algorithm = "substring"
      $env.config.completions.external.completer = $fish_completer
    '';
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
      font_family = "Maple Mono NF CN Italic";
      font_size = 17.0;
      shell = "nu";
      window_margin_width = 21.75;
      cursor_shape = "beam";
      cursor_trail = 1;
      cursor_trail_start_threshold = 0;

      "modify_font cell_height" = "+7px";
    };
  };

  # programs.fish = {
  #   enable = true;
  #   interactiveShellInit = ''
  #     cat ~/.local/state/caelestia/sequences.txt 2> /dev/null
  #     set -g fish_greeting ""
  #   '';
  # };
}
