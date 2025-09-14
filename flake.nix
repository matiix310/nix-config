{
  description = "Home Manager configuration of matiix310";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      user = import ./user.nix;
      profiles = [
        "matiix310"
      ];
      configDir = "/home/${user.username}/home-manager";
    in
    {
      homeConfigurations = builtins.listToAttrs (
        builtins.map (profile: {
          name = profile;
          value = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./profiles/${profile}/home.nix ];
            extraSpecialArgs = {
              inherit inputs;
              inherit user;
              inherit configDir;
            };
          };
        }) profiles
      );
    };
}
