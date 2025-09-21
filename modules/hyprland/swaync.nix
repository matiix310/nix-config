{ config, lib, ... }:
let
  hyprcfg = config.hyprland;
  cfg = hyprcfg.swaync;
  theme = config.theme;
in
{
  options.hyprland.swaync = {
    enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable Swaync.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (hyprcfg.enable && cfg.enable) {
    services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        control-center-margin-top = 20;
        control-center-margin-bottom = 20;
        control-center-margin-right = 20;
        control-center-margin-left = 0;
        widget-config = {
          title = {
            text = "󰂚  Notifications";
            clear-all-button = true;
            button-text = "";
          };
        };
      };
      style = ''
        * {
          font-family: JetBrainsMono NF;
          font-size: 18px;
        }

        .control-center {
          border: 2px solid ${theme.primary};
          background: ${theme.background};
          padding: 12px;
        }

        .widget-title {
        }

        .widget-title > label {
          background-image: linear-gradient(45deg,${theme.primary},${theme.primary-gradient});
          padding: 6px 16px;
          color: ${theme.background};
          border-radius: ${toString theme.roundness}px;
        }

        .widget-title > button {
          background-color: ${theme.critical};
          border-radius: ${toString theme.roundness}px;
          color: ${theme.text};
          border: none;
        }

        .widget-title > button:hover {
          opacity: 0.9;
        }

        .widget-dnd label {
          color: ${theme.text};
        }

        .widget-dnd switch {
          border-radius: 100px;
          border: none;
          background-color: ${theme.text};
        }

        .widget-dnd switch:checked {
          background-color: ${theme.critical};
        }

        .widget-dnd switch:hover {
          opacity: 0.9;
        }

        .widget-dnd switch:checked slider {
          background-color: ${theme.text};
        }

        .widget-dnd switch slider {
          border-radius: 100px;
          border: none;
          box-shadow: none;
          margin: 2px;
          background-color: ${theme.background};
        }

        .notification {
          background-color: ${theme.background-2};
          border: 2px solid ${theme.border};
          border-radius: ${toString theme.roundness}px;
          padding: 10px;
        }

        .notification .notification-default-action:hover {
          background-color: inherit;
        }
      '';
    };
  };
}
