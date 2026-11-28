{ config, ... }:

{
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
  services.mpd = {
    enable = true;
    musicDirectory = "/home/mopht/Music/file";
    playlistDirectory = "/home/mopht/Music/playlists";
    dataDir = "${config.xdg.stateHome}/mpd";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire"
      }
    '';
  };

  programs.btop.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${config.home.homeDirectory}/nixos-config";
  };

  services.hyprpolkitagent.enable = true;

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  services.wl-clip-persist = {
    enable = true;
    clipboardType = "regular";
  };

  services.easyeffects.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
      "text/html" = "zen-beta.desktop";
      "application/x-extension-htm" = "zen-beta.desktop";
      "application/x-extension-html" = "zen-beta.desktop";
      "application/x-extension-shtml" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "application/x-extension-xhtml" = "zen-beta.desktop";
      "application/x-extension-xht" = "zen-beta.desktop";
      "application/pdf" = "sioyek.desktop";
      "text/markdown" = "typora.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";

      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/ton" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";

      "x-scheme-handler/clash" = "clash-verge.desktop";
      "x-scheme-handler/clash-verge" = "clash-verge.desktop";

      "inode/directory" = "org.gnome.Nautilus.desktop";

      "image/jpeg" = "swayimg.desktop";
      "image/png" = "swayimg.desktop";
      "image/webp" = "swayimg.desktop";
      "image/gif" = "swayimg.desktop";

      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";

      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-rar" = "org.gnome.FileRoller.desktop";

      "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
      "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
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
}
