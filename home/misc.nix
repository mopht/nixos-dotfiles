{ pkgs, ... }:

{
  services.mpdris2-rs.enable = true;
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  programs.lazygit.enable = true;

  programs.rmpc.enable = true;
  programs.mpv = {
    enable = true;
    # Optional: customize the package and add bundled scripts
    scripts = with pkgs.mpvScripts; [
      uosc
      thumbfast
    ];

    config = {
      profile = "high-quality";
      hwdec = "auto-safe";
      cache-default = 4000000;
    };
  };

  home.file.".config/clangd/config.yaml".text = ''
    # Global settings for all files
    CompileFlags:
      Add: [-Wall, -Wextra]

    ---
    # Settings strictly for C++ files
    If:
      PathMatch: [.*\.cpp, .*\.hpp, .*\.cc]
    CompileFlags:
      Add: [-std=c++26, -stdlib=libc++, -xc++]

    ---
    # Settings strictly for C files
    If:
      PathMatch: .*\.c
    CompileFlags:
      Add: [-std=c17, -xc]
  '';

  programs.btop.enable = true;

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
