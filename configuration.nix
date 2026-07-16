{ config, lib, pkgs, ... }:

{
  imports =
    [ ./hosts/desktop/hardware-configuration.nix
      ./hosts/desktop/configuration.nix
      ./modules/desktop.nix
      ./modules/network.nix
      ./modules/audio.nix
      ./modules/fcitx5.nix
      ./modules/pkgs.nix
      ./modules/gaming.nix
    ];

  system.stateVersion = "26.11";
  time.timeZone = "Asia/Shanghai";

  users.users.mopht = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "i2c" "buletooth" ];
  };
}

