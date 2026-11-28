{
  inputs,
  pkgs,
  username,
  ...
}:

{
  system.stateVersion = "26.11";
  time.timeZone = "Asia/Shanghai";

  documentation.nixos.enable = false;
  documentation.doc.enable = false;
  documentation.man.cache.enable = true;

  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "8G";
  boot.consoleLogLevel = 3;

  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
  };

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.settings.warn-dirty = false;
  nix.daemonCPUSchedPolicy = "batch";
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

    trusted-users = [ username ];

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

  users.users.${username} = {
    isNormalUser = true;
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
