{ pkgs, ... }:

{
  system.stateVersion = "26.11";
  time.timeZone = "Asia/Shanghai";

  documentation.nixos.enable = false;
  documentation.man.cache.enable = false;

  nix.package = pkgs.lix;
  # 去重交给定时任务，构建时不再逐包做硬链接优化。
  # 默认的 03:45 基本碰不到你在用机器；改成周日晚，错过则由 Persistent 在下次开机补跑。
  nix.optimise = {
    automatic = true;
    dates = [ "Sun *-*-* 20:00:00" ];
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  # 自动清理旧 generation 与无引用的 store 路径。
  # `nh clean`（home/misc.nix）生成的用户服务只清理用户 profile，
  # 系统 profile 的旧代需要 root 侧的 nix-gc 来兜底。
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # 日志持久化，重启后仍能查上次启动的 journal
  services.journald.settings.Journal = {
    Storage = "persistent";
    SystemMaxUse = "1G";
  };

  users.users.mopht = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "i2c"
      "uinput"
    ];
  };
}
