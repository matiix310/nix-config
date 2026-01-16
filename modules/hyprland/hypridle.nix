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
        general {
            ${if hyprcfg.hyprlock.enable then ''
            lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
            before_sleep_cmd = loginctl lock-session    # lock before suspend.
            '' else ""}
            after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
        }

        listener {
            timeout = ${toString cfg.screenSaverTimeout}
            on-timeout = brightnessctl -s set 5    # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = brightnessctl -r           # monitor backlight restor.
        }

        listener {
            timeout = ${toString cfg.screenSaverTimeout}
            on-timeout = brightnessctl -sd platform::kbd_backlight set 0 # turn off keyboard backlight.
            on-resume = brightnessctl -rd platform::kbd_backlight        # turn on keyboard backlight.
        }

        listener {
          timeout = ${toString cfg.suspendTimeout}
          on-timeout = systemctl suspend           # suspend pc
        }
      '';
    };
  };
}
