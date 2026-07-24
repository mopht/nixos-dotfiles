{ config, pkgs, inputs, ... }:

{
  services.mpdris2-rs.enable = true;

  programs.lazygit.enable = true;

  programs.mpv = {
    enable = true;
    # Optional: customize the package and add bundled scripts
    package = (pkgs.mpv-unwrapped.wrapper {
      scripts = with pkgs.mpvScripts; [
        uosc
        thumbfast
      ];
    });

    config = {
      profile = "high-quality";
      hwdec = "auto-safe";
      cache-default = 4000000;
    };
  };

  home.file.".config/clangd/config.yaml".text = ''
    CompileFlags:
      Add: [-std=c++26, -stdlib=libc++]
  '';

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };
}
