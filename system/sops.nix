{
  config,
  pkgs,
  username,
  ...
}:

{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets.mopht-passwd.neededForUsers = true;

    secrets.danmaku-filter = {
      owner = username;
      mode = "0400";
    };
  };

  users.users.${username}.hashedPasswordFile = config.sops.secrets.mopht-passwd.path;

  environment.shells = [
    pkgs.nushell
    pkgs.fish
  ];
  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
