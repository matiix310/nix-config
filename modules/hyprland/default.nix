{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.hyprland;
in
{
  options.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
  };

  imports = [
    ./waybar.nix
    ./hypridle.nix
    ./hyprlock.nix
  ];

  config = lib.mkIf cfg.enable {
    # TODO: add hyprland
    home.packages = with pkgs; [
      hyprpaper
    ];

    home.file = {
      ".config/hypr/hyprpaper.conf".text = ''
        preload = ${config.theme.wallpaper}
        # If more than one preload is desired then continue to preload other backgrounds
        # preload = /path/to/next_image.png
        # ... more preloads

        # Set the default wallpaper(s) seen on initial workspace(s) --depending on the number of monitors used
        wallpaper = ,${config.theme.wallpaper}
        # If more than one monitor in use, can load a 2nd image
        # wallpaper = monitor2,/path/to/next_image.png
        # ... more monitors

        # Enable splash text rendering over the wallpaper
        splash = false

        # Fully disable ipc
        ipc = off
      '';
    };
  };
}
