{ lib, ... }:
{
  imports = [
    ./development
    ./hyprland
    ./terminal
    ./desktop
    ./nixgl.nix
  ];

  options = {
    theme = lib.mkOption { type = lib.types.attrs; };
    monitors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    kb_layout = lib.mkOption {
      type = lib.types.str;
      default = "us";
    };
  };
}
