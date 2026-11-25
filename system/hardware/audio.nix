{ config, ... }:

{
  services.power-profiles-daemon.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };

  services.mpd = {
    enable = true;
    user = "mopht";
    settings = {
      music_directory = "/home/mopht/Music/file";
      playlist_directory = "/home/mopht/Music/playlists";
      db_file = "/home/mopht/Music/mpd.db";
      state_file = "/home/mopht/Music/mpdstate";

      audio_output = [
        {
          type = "pipewire";
          name = "Home Manager MPD";
        }
      ];
    };
  };

  # 注意：systemd 的 %U 在系统服务里固定展开成 0（运行 manager 的用户），
  # 不受 User= 影响，所以这里必须写实际 UID。
  systemd.services.mpd.environment.XDG_RUNTIME_DIR =
    "/run/user/${toString config.users.users.mopht.uid}";
}
