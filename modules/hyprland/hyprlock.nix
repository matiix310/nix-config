{
  pkgs,
  lib,
  config,
  ...
}:
let
  hyprcfg = config.hyprland;
  cfg = hyprcfg.hyprlock;
  theme = config.theme;
in
{
  options.hyprland.hyprlock = {
    enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable hyprlock.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (hyprcfg.enable && cfg.enable) {
    programs.hyprlock.enable = true;
    programs.hyprlock.package = config.lib.nixGL.wrap pkgs.hyprlock;

    home.file = {
      ".config/hypr/hyprlock.conf".text = ''
        background {
          monitor =
          path = screenshot

          blur_passes = 2 # 0 disables blurring
          blur_size = 3
          noise = 0.0117
          contrast = 0.8916
          brightness = 0.8172
          vibrancy = 0.1696
          vibrancy_darkness = 0.0
        }

        background {
          monitor =
          path = ${theme.lockscreen}
        }

        input-field {
          monitor =
          size = 400, 100
          outline_thickness = 3
          dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = false
          dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
          outer_color = rgb(151515)
          inner_color = rgb(200, 200, 200)
          font_color = rgb(10, 10, 10)
          fade_on_empty = true
          placeholder_text = <i></i> # Text rendered in the input box when it's empty.
          hide_input = false
          rounding = -1 # -1 means complete rounding (circle/oval)

          position = 0, -20
          halign = center
          valign = center
        }
      '';
    };
  };
}
