{ pkgs, ... }:

{
  system.stateVersion = "26.11";
  time.timeZone = "Asia/Shanghai";

  documentation.nixos.enable = false;
  documentation.doc.enable = false;
  documentation.man.cache.enable = false;

  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "4G";

  nix.package = pkgs.lix;
  nix.optimise = {
    automatic = true;
    dates = [ "Sun *-*-* 20:00:00" ];
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
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
