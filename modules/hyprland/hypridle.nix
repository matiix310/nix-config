{
  pkgs,
  lib,
  config,
  ...
}:
let
  hyprcfg = config.hyprland;
  cfg = hyprcfg.hypridle;
in
{
  options.hyprland.hypridle = {
    enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable Hypridle.";
      type = lib.types.bool;
    };
    screenSaverTimeout = lib.mkOption {
      description = "Timeout before lowering the screen brightness (in seconds).";
      default = 150;
      type = lib.types.ints.positive;
    };
    suspendTimeout = lib.mkOption {
      description = "Timeout before suspending the system (in seconds).";
      default = 1800;
      type = lib.types.ints.positive;
    };
  };

  config = lib.mkIf (hyprcfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      hypridle
    ];

    home.file = {
      ".config/hypr/hypridle.conf".text = ''
        listener {
            timeout = ${toString cfg.screenSaverTimeout}
            on-timeout = brightnessctl -s set 5    # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = brightnessctl -r           # monitor backlight restor.
        }

        listener {
          timeout = ${toString cfg.suspendTimeout}
          on-timeout = systemctl suspend           # suspend pc
        }
      '';
    };
  };
}
