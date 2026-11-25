{ config, pkgs, ... }:

{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets.mopht-passwd.neededForUsers = true;
  };

  users.users.mopht.hashedPasswordFile = config.sops.secrets.mopht-passwd.path;

  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
