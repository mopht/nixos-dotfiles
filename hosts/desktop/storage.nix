# 快照与数据校验。这些不是 nixos-generate-config 的产物，
# 单独放这里，重新生成 hardware.nix 时不会丢。
{ ... }:

{
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [
      "/"
      "/home"
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
    };
  };
}
