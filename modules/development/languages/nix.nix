{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.lang.nix;
in
{
  options.lang.nix = {
    enable = lib.mkEnableOption "Nix language support";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nixfmt-rfc-style # nix formatter
      nil
    ];
  };
}
