{ pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    # Optional Nvidia hardware acceleration
    package = (pkgs.obs-studio.override { cudaSupport = true; });
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
    ];
  };

  services.mpdris2-rs.enable = true;
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  programs.rmpc.enable = true;
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      uosc
      quality-menu
      thumbfast
      evafast

      mpv-playlistmanager
      mpris
    ];

    config = {
      target-colorspace-hint = "no";
      autocreate-playlist = "filter";

      profile = "high-quality";
      hwdec = "vaapi";
      vo = "gpu";
      gpu-context = "wayland";
      video-sync = "display-resample";
      interpolation = "yes";

      cache = "yes";
      demuxer-max-bytes = "4000M";
      osc = "no";
      border = "no";
    };

    bindings = {
      UP   = "add volume 5";
      DOWN = "add volume -5";
    };

    scriptOpts.uosc = {
      timeline_style = "bar";
      progress = "always";
      progress_size = 2;
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
