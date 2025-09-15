{
  description = "Home Manager configuration of matiix310";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixgl,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        # pkgs = nixpkgs.legacyPackages.${system};
        user = import ./user.nix;
        profiles = [
          "matiix310"
        ];
        configDir = "/home/${user.username}/home-manager";
      in
      {
        packages.homeConfigurations = builtins.listToAttrs (
          builtins.map (profile: {
            name = profile;
            value = home-manager.lib.homeManagerConfiguration {
              pkgs = import nixpkgs {
                inherit system;
                overlays = [ (nixgl.overlays.default) ];
                config = {
                  allowUnfree = true; # needed for nvidia driver
                };
              };
              modules = [ ./profiles/${profile}/home.nix ];
              extraSpecialArgs = {
                inherit
                  inputs
                  user
                  configDir
                  nixgl
                  ;
              };
            };
          }) profiles
        );
      }
    );
}
