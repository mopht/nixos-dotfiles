{ ... }:

{
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    # "/" 和 "/home" 在同一个文件系统上（btrfs @ / @home），
    # scrub "/" 已经覆盖整个设备，再列 /home 会白扫一遍。
    fileSystems = [
      "/"
      "/home/mopht/Game"
      "/home/mopht/Music"
    ];
  };

  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1d";
    configs = {
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "mopht" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 5;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 2;
        TIMELINE_LIMIT_MONTHLY = 2;
      };

      # 需要 /home/mopht/Music 是真正的 btrfs 子卷（subvol=music）才会生效，
      # 见 hosts/desktop/mounts.nix 和 scripts/migrate-music-subvol.sh。
      music = {
        SUBVOLUME = "/home/mopht/Music";
        ALLOW_USERS = [ "mopht" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 2;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 2;
        TIMELINE_LIMIT_MONTHLY = 2;
      };
    };
  };
}
