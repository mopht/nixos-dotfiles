# 手工维护的额外挂载点。
# 放在这里而不是 hardware.nix
# 重新生成时手工添加的 fileSystems 会被覆盖掉。
{ username, ... }:

{
  fileSystems."/home/${username}/Game" = {
    device = "/dev/disk/by-uuid/e4e3d91e-3d73-407d-9561-f3d2b578ebc8";
    fsType = "btrfs";
    options = [
      "compress=zstd:1"
      "nofail"
      "noatime"
      "discard=async"
    ];
  };

  fileSystems."/home/${username}/Music" = {
    device = "/dev/disk/by-uuid/80ff9653-538b-4cd0-ad8e-e638bb883ad0";
    fsType = "btrfs";
    options = [
      "subvol=music"
      "compress=zstd"
      "nofail"
      "noatime"
      "discard=async"
    ];
  };

  # ~/.cache 单独一个子卷：这样 /home 的 hourly 快照不会把缓存一起快照。
  # 子卷名 @cache，和 @ / @home 的命名保持一致。
  #
  # 首次切换前先建子卷（见 README「~/.cache 子卷」）：
  # sudo btrfs subvolume create <@home 所在 fs 的挂载点>/@cache
  fileSystems."/home/${username}/.cache" = {
    device = "/dev/disk/by-uuid/bdaa131f-07d1-419c-b593-4783d11e0b43";
    fsType = "btrfs";
    options = [
      "subvol=@cache"
      "compress=zstd"
      "nofail"
      "noatime"
      "discard=async"
    ];
  };

  # btrfs subvolume create 建出来的根目录是 root:root，挂到 ~/.cache 后
  # 用户会写不进去，这里统一改成该用户。挂载失败时（nofail）也能兜底建出目录。
  systemd.tmpfiles.rules = [ "d /home/${username}/.cache 0700 ${username} users -" ];
}
