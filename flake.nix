{
  description = "KDE Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    stylix.url = "github:danth/stylix";
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ...
  }: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        modules = [
          stylix.nixosModules.stylix
          ./configuration.nix
        ];
      };
    };
    homeConfigurations = {
      adam = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home.nix];
      };
    };
  };
}
