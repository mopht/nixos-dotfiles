{ pkgs, lib, config, ... }:

let
  a4k = "${pkgs.anime4k}";

  anime4k-720p-a = lib.concatStringsSep ":" [
    "${a4k}/Anime4K_Clamp_Highlights.glsl"
    "${a4k}/Anime4K_Restore_CNN_M.glsl"
    "${a4k}/Anime4K_Upscale_CNN_x2_L.glsl"
  ];
  anime4k-720p-sharp = lib.concatStringsSep ":" [
    "${a4k}/Anime4K_Clamp_Highlights.glsl"
    "${a4k}/Anime4K_Restore_CNN_M.glsl"
    "${a4k}/Anime4K_Thin_HQ.glsl"
    "${a4k}/Anime4K_Darken_HQ.glsl"
    "${a4k}/Anime4K_Upscale_CNN_x2_L.glsl"
  ];
  anime4k-720p-denoise = lib.concatStringsSep ":" [
    "${a4k}/Anime4K_Clamp_Highlights.glsl"
    "${a4k}/Anime4K_Upscale_Denoise_CNN_x2_L.glsl"
  ];

  anime4k-720p-a-VL = lib.concatStringsSep ":" [
    "${a4k}/Anime4K_Clamp_Highlights.glsl"
    "${a4k}/Anime4K_Restore_CNN_L.glsl"
    "${a4k}/Anime4K_Upscale_CNN_x2_VL.glsl"
  ];
  anime4k-720p-sharp-VL = lib.concatStringsSep ":" [
    "${a4k}/Anime4K_Clamp_Highlights.glsl"
    "${a4k}/Anime4K_Restore_CNN_L.glsl"
    "${a4k}/Anime4K_Thin_HQ.glsl"
    "${a4k}/Anime4K_Darken_HQ.glsl"
    "${a4k}/Anime4K_Upscale_CNN_x2_VL.glsl"
  ];
  anime4k-720p-denoise-VL = lib.concatStringsSep ":" [
    "${a4k}/Anime4K_Clamp_Highlights.glsl"
    "${a4k}/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl"
  ];
in

{
  programs.obs-studio = {
    enable = true;
    package = (pkgs.obs-studio.override { cudaSupport = true; });
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
    ];
  };

  services.mpdris2-rs.enable = true;
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

      reload
      smartskip
    ];

    config = {
      ytdl-format = "bestvideo+bestaudio/best";
      ytdl-raw-options =
        ''cookies-from-browser=firefox:${config.home.homeDirectory}/.config/zen/${config.programs.zen-browser.profiles.default.path},format-sort="res,fps,vcodec:av01:vp9:hevc:h264,tbr"'';
      target-colorspace-hint = false;
      autocreate-playlist = "filter";
      save-position-on-quit = true;


      profile = "high-quality";
      hwdec = "vaapi";
      vo = "gpu-next";
      gpu-context = "waylandvk";
      tscale = "oversample";
      video-sync = "display-resample";
      gpu-api = "vulkan";
      interpolation = true;

      blend-subtitles = false;

      prefetch-playlist = true;
      demuxer-max-bytes = "1000M";
      demuxer-max-back-bytes = "300M";
      osc = false;
      osd-bar = false;
      border = false;
    };

    bindings = {
      MBTN_LEFT = "cycle pause";
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
      z = "set speed 1.0";

      "Ctrl+1" = ''no-osd change-list glsl-shaders set "${anime4k-720p-a}"; show-text "Anime4K: 720p->1080p (L Balanced)"'';
      "Ctrl+2" = ''no-osd change-list glsl-shaders set "${anime4k-720p-sharp}"; show-text "Anime4K: 720p->1080p (L Ultra Sharp)"'';
      "Ctrl+3" = ''no-osd change-list glsl-shaders set "${anime4k-720p-denoise}"; show-text "Anime4K: 720p->1080p (L Denoise)"'';
      "Ctrl+5" = ''no-osd change-list glsl-shaders set "${anime4k-720p-a-VL}"; show-text "Anime4K: 720p->1080p (VL Balanced)"'';
      "Ctrl+6" = ''no-osd change-list glsl-shaders set "${anime4k-720p-sharp-VL}"; show-text "Anime4K: 720p->1080p (VL Ultra Sharp)"'';
      "Ctrl+7" = ''no-osd change-list glsl-shaders set "${anime4k-720p-denoise-VL}"; show-text "Anime4K: 720p->1080p (VL Denoise)"'';
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
      api_server = "https://danmaku-api.152468.xyz";
      auto_load = true;
      autoload_for_url = true;
      load_more_danmaku = true;


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

      blacklist_path= "/etc/nixos/home/apps/filter.txt";
    };

    scriptOpts.quality-menu.fetch_formats = true;
  };
}
