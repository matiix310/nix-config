{ config, lib, ... }:
let
  hyprcfg = config.hyprland;
  cfg = hyprcfg.flags;
  flagOption = (
    name:
    lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable the ${name} flags.";
      type = lib.types.bool;
    }
  );
in
{
  options.hyprland.flags = {
    electron.enable = flagOption "electron";
    chromium.enable = flagOption "chromium";
  };

  config = lib.mkIf hyprcfg.enable {
    home.file.".config/electron-flags.conf" = lib.mkIf cfg.electron.enable {
      text = ''
        --enable-features=UseOzonePlatform
        --ozone-platform=wayland
      '';
    };

    home.file.".config/electron32-flags.conf" = lib.mkIf cfg.electron.enable {
      text = ''
        --enable-features=UseOzonePlatform
        --ozone-platform=wayland
      '';
    };

    home.file.".config/chromium-flags.conf" = lib.mkIf cfg.chromium.enable {
      text = ''
        --ozone-platform-hint=auto
      '';
    };
  };
}
