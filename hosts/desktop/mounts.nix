# 手工维护的额外挂载点。
# 放在这里而不是 hardware.nix：那个文件由 nixos-generate-config 生成，
# 重新生成时手工添加的 fileSystems 会被覆盖掉。
{ ... }:

{
  fileSystems."/home/mopht/Game" = {
    device = "/dev/disk/by-uuid/e4e3d91e-3d73-407d-9561-f3d2b578ebc8";
    fsType = "btrfs";
    options = [
      "compress=zstd:1"
      "nofail"
      "noatime"
      "discard=async"
    ];
  };

  # btrfs 不能对顶层 subvolume（subvolid=5）做快照，而 snapper 的 music
  # 配置需要的是一个真正的子卷，所以这里挂 subvol=music。
  #
  # ⚠️ 首次切换前先跑：sudo ./scripts/migrate-music-subvol.sh
  # 该脚本会把顶层里的数据搬进 music 子卷并自动 rebuild。
  # 如果先 rebuild 了也没关系（nofail，系统照常启动），补跑脚本即可。
  fileSystems."/home/mopht/Music" = {
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
}
