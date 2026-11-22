{ pkgs, ... }:

{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/mopht/.config/sops/age/keys.txt";

    # Secrets definition example:
    # secrets."example-secret" = {
    #   owner = "mopht";
    # };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
