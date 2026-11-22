{ pkgs, ... }:

{
  system.stateVersion = "26.11";
  time.timeZone = "Asia/Shanghai";

  documentation.nixos.enable = false;
  documentation.man.cache.enable = false;

  nix.package = pkgs.lix;
  nix.settings.auto-optimise-store = true;
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
