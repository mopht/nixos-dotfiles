{ pkgs, ... }:

{
  system.stateVersion = "26.11";
  time.timeZone = "Asia/Shanghai";

  documentation.nixos.enable = false;
  documentation.doc.enable = false;
  documentation.man.cache.enable = false;

  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "12G";

  nix.package = pkgs.lix;
  nix.optimise = {
    automatic = true;
    dates = [ "Sun *-*-* 20:00:00" ];
  };
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # 允许 mopht 自己临时指定 substituter / 覆盖设置（root 由 nixpkgs 模块默认加上）
    trusted-users = [ "mopht" ];

    # nixpkgs 模块会自动加上 cache.nixos.org（mkAfter），这里只补额外的缓存；
    # 国内可再加镜像，例如 "https://mirrors.ustc.edu.cn/nix-channels/store"
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  services.journald.settings.Journal = {
    Storage = "persistent";
    SystemMaxUse = "1G";
  };

  users.users.mopht = {
    isNormalUser = true;
    # 固定 UID：MPD 的系统服务需要写死 XDG_RUNTIME_DIR（见 system/hardware/audio.nix）
    uid = 1000;
    shell = pkgs.nushell;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
      "i2c"
      "uinput"
    ];
  };
}
