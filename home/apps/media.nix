{
  pkgs,
  lib,
  config,
  ...
}:

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
      ytdl-raw-options = ''cookies-from-browser=firefox:${config.home.homeDirectory}/.config/zen/${config.programs.zen-browser.profiles.default.path},format-sort="res,vcodec:av01:vp9:hevc:h264,tbr"'';
      target-colorspace-hint = false;
      autocreate-playlist = "filter";
      save-position-on-quit = true;
      force-window = "immediate";

      profile = "high-quality";
      hwdec = "vaapi";
      vo = "gpu-next";
      gpu-context = "waylandvk";
      tscale = "oversample";
      video-sync = "display-resample";
      gpu-api = "vulkan";
      interpolation = true;

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
      UP = "no-osd add volume 5; script-message-to uosc flash-elements volume";
      DOWN = "no-osd add volume -5; script-message-to uosc flash-elements volume";
      WHEEL_UP = "no-osd add volume 2; script-message-to uosc flash-elements volume";
      WHEEL_DOWN = "no-osd add volume -2; script-message-to uosc flash-elements volume";
      m = "no-osd cycle mute; script-message-to uosc flash-elements volume";
      d = "cycle sub-visibility";
      c = "cycle sub";
      "[" = "playlist-prev";
      "]" = "playlist-next";
      z = "set speed 1.0";

      "Ctrl+1" =
        ''no-osd change-list glsl-shaders set "${anime4k-720p-a}"; show-text "Anime4K: 720p->1080p (L Balanced)"'';
      "Ctrl+2" =
        ''no-osd change-list glsl-shaders set "${anime4k-720p-sharp}"; show-text "Anime4K: 720p->1080p (L Ultra Sharp)"'';
      "Ctrl+3" =
        ''no-osd change-list glsl-shaders set "${anime4k-720p-denoise}"; show-text "Anime4K: 720p->1080p (L Denoise)"'';
      "Ctrl+5" =
        ''no-osd change-list glsl-shaders set "${anime4k-720p-a-VL}"; show-text "Anime4K: 720p->1080p (VL Balanced)"'';
      "Ctrl+6" =
        ''no-osd change-list glsl-shaders set "${anime4k-720p-sharp-VL}"; show-text "Anime4K: 720p->1080p (VL Ultra Sharp)"'';
      "Ctrl+7" =
        ''no-osd change-list glsl-shaders set "${anime4k-720p-denoise-VL}"; show-text "Anime4K: 720p->1080p (VL Denoise)"'';
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

      blacklist_path = "/etc/nixos/home/apps/filter.txt";
    };

    scriptOpts.ytdl_hook.all_formats = false;

    scriptOpts.quality-menu.fetch_formats = true;
  };

  xdg.configFile."swayimg/init.lua".text = ''
    -- Swayimg Configuration for Wayland / Hyprland

    -- General
    swayimg.mode = "viewer"
    swayimg.antialiasing = true
    swayimg.decoration = false
    swayimg.overlay = false
    swayimg.exif_orientation = true

    -- Text overlay (press 'i' or 't' to toggle)
    swayimg.text.visible = false
    swayimg.text.font = "Maple Mono NF CN"
    swayimg.text.size = 18
    swayimg.text.padding = 12
    swayimg.text.color = 0xffe0e0e0
    swayimg.text.background = 0x88181825
    swayimg.text.shadow = 0x00000000
    swayimg.text.timeout = 4

    -- Viewer mode
    swayimg.viewer.default_scale = "optimal"
    swayimg.viewer.default_position = "center"
    swayimg.viewer.drag_button = "MouseLeft"
    swayimg.viewer.autopos = "center"
    swayimg.viewer.loop = true
    swayimg.viewer.preload = 2
    swayimg.viewer.history = 2
    swayimg.viewer.set_window_background("auto")

    swayimg.viewer.text = {
      topleft = {
        "File: {name}",
        "Size: {sizehr} ({frame.width}x{frame.height})",
        "Format: {format}",
      },
      topright = {
        "{list.index} / {list.total}",
      },
      bottomleft = {
        "Scale: {scale}",
      },
    }

    -- Keybindings: Viewer mode
    swayimg.viewer.on_key("q", function() swayimg.exit() end)
    swayimg.viewer.on_key("Escape", function() swayimg.exit() end)

    -- Navigation
    swayimg.viewer.on_key("Right", function() swayimg.viewer.open("next") end)
    swayimg.viewer.on_key("Left", function() swayimg.viewer.open("prev") end)
    swayimg.viewer.on_key("l", function() swayimg.viewer.open("next") end)
    swayimg.viewer.on_key("h", function() swayimg.viewer.open("prev") end)
    swayimg.viewer.on_key("space", function() swayimg.viewer.open("next") end)
    swayimg.viewer.on_key("BackSpace", function() swayimg.viewer.open("prev") end)

    -- Zoom & Scale
    swayimg.viewer.on_key("equal", function()
      swayimg.viewer.scale = swayimg.viewer.scale * 1.15
    end)
    swayimg.viewer.on_key("minus", function()
      swayimg.viewer.scale = swayimg.viewer.scale / 1.15
    end)
    swayimg.viewer.on_key("0", function() swayimg.viewer.reset() end)

    -- Mode switches & features
    swayimg.viewer.on_key("f", function() swayimg.fullscreen = not swayimg.fullscreen end)
    swayimg.viewer.on_key("g", function() swayimg.mode = "gallery" end)
    swayimg.viewer.on_key("Return", function() swayimg.mode = "gallery" end)
    swayimg.viewer.on_key("i", function() swayimg.text.visible = not swayimg.text.visible end)
    swayimg.viewer.on_key("t", function() swayimg.text.visible = not swayimg.text.visible end)
    swayimg.viewer.on_key("s", function() swayimg.mode = "slideshow" end)

    -- Rotate & Flip
    swayimg.viewer.on_key("r", function() swayimg.viewer.rotate(90) end)
    swayimg.viewer.on_key("R", function() swayimg.viewer.rotate(270) end)
    swayimg.viewer.on_key("m", function() swayimg.viewer.flip_horizontal() end)
    swayimg.viewer.on_key("M", function() swayimg.viewer.flip_vertical() end)

    -- Move to trash
    swayimg.viewer.on_key("Delete", function()
      local img = swayimg.viewer.get_image()
      if img then
        os.execute(string.format("trash-put %q 2>/dev/null", img.path))
        swayimg.imagelist.remove(img.path)
      end
    end)

    -- Mouse zoom & pan
    swayimg.viewer.on_scroll(function(kmods, horizontal, vertical)
      if vertical and vertical ~= 0 then
        local mouse = swayimg.get_mouse_pos()
        local scale = swayimg.viewer.scale
        -- vertical < 0 is scroll up (zoom in), vertical > 0 is scroll down (zoom out)
        local factor = vertical < 0 and 1.15 or (1 / 1.15)
        swayimg.viewer.set_abs_scale(scale * factor, mouse.x, mouse.y)
      elseif horizontal and horizontal ~= 0 then
        local pos = swayimg.viewer.get_position()
        swayimg.viewer.set_abs_position(pos.x + math.floor(horizontal * 40), pos.y)
      end
    end)

    -- Gallery mode
    swayimg.gallery.thumb_size = 200
    swayimg.gallery.aspect = "fill"
    swayimg.gallery.padding_size = 6
    swayimg.gallery.border_size = 3
    swayimg.gallery.border_color = 0xff89b4fa
    swayimg.gallery.selected_color = 0x33ffffff
    swayimg.gallery.unselected_color = 0x11ffffff
    swayimg.gallery.window_color = 0xdd181825
    swayimg.gallery.hover = true
    swayimg.gallery.cache = 150
    swayimg.gallery.embedded_thumb = true

    swayimg.gallery.on_key("q", function() swayimg.exit() end)
    swayimg.gallery.on_key("Escape", function() swayimg.exit() end)
    swayimg.gallery.on_key("Return", function() swayimg.mode = "viewer" end)
    swayimg.gallery.on_key("space", function() swayimg.mode = "viewer" end)
    swayimg.gallery.on_key("f", function() swayimg.fullscreen = not swayimg.fullscreen end)
    swayimg.gallery.on_key("h", function() swayimg.gallery.select("left") end)
    swayimg.gallery.on_key("j", function() swayimg.gallery.select("down") end)
    swayimg.gallery.on_key("k", function() swayimg.gallery.select("up") end)
    swayimg.gallery.on_key("l", function() swayimg.gallery.select("right") end)
    swayimg.gallery.on_key("Left", function() swayimg.gallery.select("left") end)
    swayimg.gallery.on_key("Down", function() swayimg.gallery.select("down") end)
    swayimg.gallery.on_key("Up", function() swayimg.gallery.select("up") end)
    swayimg.gallery.on_key("Right", function() swayimg.gallery.select("right") end)

    -- Slideshow mode
    swayimg.slideshow.timeout = 4
    swayimg.slideshow.default_scale = "fit"
    swayimg.slideshow.on_key("s", function() swayimg.mode = "viewer" end)
    swayimg.slideshow.on_key("q", function() swayimg.exit() end)
    swayimg.slideshow.on_key("Escape", function() swayimg.mode = "viewer" end)
  '';
}
