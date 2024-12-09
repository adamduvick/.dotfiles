{
  description = "My NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    mkSystem = system: hostName: user:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {networking.hostName = hostName;}
          ./modules/system/configuration.nix
          ./hosts/laptop/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = {inherit inputs;};
              users.${user} = ./hosts/laptop/home.nix;
            };
          }
        ];
        specialArgs = {inherit inputs;};
      };
  in {
    nixosConfigurations = {
      nixos = mkSystem "x86_64-linux" "nixos" "adam";
    };
  };
}
