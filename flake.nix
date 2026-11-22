{
  description = "mopht's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/";

    moonbit-overlay = {
      url = "github:moonbit-community/moonbit-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      moonbit-overlay,
      nix-flatpak,
      sops-nix,
      ...
    }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      # `nix flake check` 会把系统和 Home Manager 配置实际构建一遍，
      # 在 nh os switch 之前就能发现评估/构建错误。
      checks.x86_64-linux = {
        nixos = self.nixosConfigurations.nixos.config.system.build.toplevel;
        home-manager =
          self.nixosConfigurations.nixos.config.home-manager.users.mopht.home.activationPackage;
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktop
          sops-nix.nixosModules.sops

          nix-flatpak.nixosModules.nix-flatpak
          {
            nixpkgs.overlays = [ moonbit-overlay.overlays.default ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.mopht = import ./home/default.nix;
          }
        ];
      };
    };
}
