{  inputs, pkgs, config, ... }:

let
  bilibili-comments = pkgs.mpvScripts.buildLua {
    pname = "MPV-Play-BiliBili-Comments";
    version = "git";
    src = inputs.biliBili-comments;
    scriptPath = "scripts/bilibiliAssert/.";
    passthru.scriptName = "bilibili_comments";
  };
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
      uosc
      quality-menu
      thumbfast
      evafast

      mpv-playlistmanager
      mpris
      bilibili-comments
    ];

    config = {
      ytdl-format = "bestvideo+bestaudio/best";
      vid = "auto";
      hls-bitrate = "max";
      ytdl-raw-options =
        ''cookies-from-browser=firefox:${config.home.homeDirectory}/.config/zen/${config.programs.zen-browser.profiles.default.path},extractor-args="youtube:player_client=tv,default",format-sort="res,fps,vcodec:av01:vp9:hevc:h264,tbr"'';
      script-opts = "ytdl_hook-ytdl_path=${pkgs.yt-dlp}/bin/yt-dlp";
      target-colorspace-hint = "no";
      autocreate-playlist = "filter";

      profile = "high-quality";
      hwdec = "vaapi";
      vo = "gpu-next";
      gpu-context = "wayland";
      video-sync = "display-resample";
      interpolation = "yes";

      prefetch-playlist = "yes";
      cache = "yes";
      demuxer-max-bytes = "1000M";
      demuxer-max-back-bytes = "300M";
      osc = "no";
      border = "no";
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
    };

    scriptOpts.uosc = {
      timeline_style = "bar";
      progress = "always";
      progress_size = 2;
    };

    scriptOpts.bilibili_comments = {
      mincount = 1;
      fontname = "sans-serif";
      fontsize = "29";
      opacity = "1";
      percent = "0";
      duration_marquee = "10";
      duration_still = "8";
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
