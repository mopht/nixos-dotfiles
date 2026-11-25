{ ... }:

{
  programs.fish.enable = true;
  programs.carapace.enable = true;
  programs.starship.enable = true;

  xdg.configFile."starship.toml" = {
    source = ./starship.toml;
    force = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    icons = "always";
    extraOptions = [
      "--group-directories-first"
      "-1"
    ];
  };

  programs.nushell = {
    loadSessionVariables = true;
    enable = true;
    settings = {
      show_banner = false;
      completions.external.enable = true;
      completions.external.max_results = 100;
      completions.algorithm = "substring";
    };

    shellAliases = {
      ll = "ls -l";
      la = "ls -a";
    };

    extraConfig = ''
      if ($"($env.HOME)/.local/state/caelestia/sequences.txt" | path exists) {
        open --raw ~/.local/state/caelestia/sequences.txt | print -n
      }
      let commands_completed_by_fish = [nu git niri tailscale]

      let fish_completer = {|place|
          let spans = $place.command
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
      font_family = "Maple Mono NF CN";
      font_size = 17.0;
      shell = "nu";
      window_margin_width = 21.75;
      cursor_shape = "beam";
      cursor_trail = 1;
      cursor_trail_start_threshold = 0;

      "modify_font cell_height" = "+7px";
    };
  };
}
