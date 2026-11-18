{ pkgs, lib, config, ... }:

    let
  a4k = "${pkgs.anime4k}";

  # 专为 720p -> 1080p 设计的单次超分链（720p x2 = 1440p，由 MPV 自动缩至 1080p，不再二次超分到 5K）
  # 档位 A：清晰片源（推荐，兼顾线条锐化与高刷流畅度）
  anime4k-720p-a = lib.concatStringsSep ":" [
    "${a4k}/Anime4K_Clamp_Highlights.glsl"
    "${a4k}/Anime4K_Restore_CNN_M.glsl"
    "${a4k}/Anime4K_Upscale_CNN_x2_L.glsl"
  ];

  # 档位 B：高糊/低码率旧番（带去噪点，不强行锐化瑕疵）
  anime4k-720p-b = lib.concatStringsSep ":" [
    "${a4k}/Anime4K_Clamp_Highlights.glsl"
    "${a4k}/Anime4K_Upscale_Denoise_CNN_x2_L.glsl"
  ];
in
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
      memo
      uosc
      quality-menu
      thumbfast
      evafast

      mpv-playlistmanager
      mpris
      uosc-danmaku

      smartskip
    ];

    config = {
      ytdl-format = "bestvideo+bestaudio/best";
      vid = "auto";
      hls-bitrate = "max";
      ytdl-raw-options =
        ''cookies-from-browser=firefox:${config.home.homeDirectory}/.config/zen/${config.programs.zen-browser.profiles.default.path},format-sort="res,fps,vcodec:av01:vp9:hevc:h264,tbr"'';
      script-opts = "ytdl_hook-ytdl_path=${pkgs.yt-dlp}/bin/yt-dlp";
      target-colorspace-hint = false;
      autocreate-playlist = "filter";
      save-position-on-quit = true;

      profile = "high-quality";
      hwdec = "vaapi";
      vo = "gpu-next";
      gpu-context = "waylandvk";
      video-sync = "display-resample";
      gpu-api = "vulkan";
      interpolation = true;

      prefetch-playlist = true;
      cache = true;
      demuxer-max-bytes = "1000M";
      demuxer-max-back-bytes = "300M";
      osc = false;
      osd-bar = false;
      border = false;
    };

    bindings = {
      MBTN_LEFT = "cycle pause";
      MBTN_LEFT_DBL = "cycle fullscreen";
      f = "cycle fullscreen";
      ESC = "set fullscreen no";
      w = "cycle window-maximized";
      t = "cycle border";
      UP = "add volume 5";
      DOWN = "add volume -5";
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
      d = "cycle sub-visibility";
      c = "cycle sub";
      "[" = "playlist-prev";
      "]" = "playlist-next";
      ">" = "add speed 0.25";
      "<" = "add speed -0.25";
      z = "set speed 1.0";
      s = "screenshot";

      "Ctrl+1" = ''no-osd change-list glsl-shaders set "${anime4k-720p-a}"; show-text "Anime4K: 720p->1080p (Standard)"'';
      "Ctrl+2" = ''no-osd change-list glsl-shaders set "${anime4k-720p-b}"; show-text "Anime4K: 720p->1080p (Denoise)"'';
      "Ctrl+0" = ''no-osd change-list glsl-shaders clr ""; show-text "GLSL Shaders: Cleared"'';
    };

    scriptOpts.playlistmanager = {
      resolve_url_titles = true;
      resolve_title_timeout = 15;
    };

    scriptOpts.uosc = {
      timeline_style = "bar";
      progress = "always";
      progress_size = 2;
      refine = "text";
    };

    scriptOpts.uosc_danmaku = {
      auto_load = true;
      autoload_for_url = true;

      opacity = 1;
      vf_fps = true;
      fps = "164.99899";

      merge_tolerance = 1;
      scrolltime = 15;
      fixtime = 8;
      fontname = "sans-serif";
      fontsize = 30;
      bold = false;
      displayarea = 1;
      outline = 1;
    };

    scriptOpts.quality-menu.fetch_formats = true;
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
    nativeMessagingHosts = [ pkgs.ff2mpv ];
    profiles.default = {
      isDefault = true;
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };
}
