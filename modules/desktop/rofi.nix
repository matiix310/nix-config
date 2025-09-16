{
  pkgs,
  lib,
  config,
  pkgs-unstable,
  ...
}:
let
  cfg = config.desktop.rofi;
  theme = config.theme;
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  options.desktop.rofi = {
    enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable Rofi.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs-unstable.rofi;
      extraConfig = {
        modi = "run,drun,window";
        icon-theme = "Oranchelo";
        show-icons = true;
        terminal = "kitty";
        drun-display-format = "{icon} {name}";
        location = 0;
        disable-history = false;
        hide-scrollbar = true;
        display-drun = "   Apps ";
        display-run = "   Run ";
        display-window = " 󰕰  Window";
        display-Network = " 󰤨  Network";
        sidebar-mode = true;
      };
      theme = {
        "*" = {
          background = mkLiteral theme.background;
          primary = mkLiteral theme.primary;
          secondary = mkLiteral theme.secondary;
          primary-gradient = mkLiteral theme.primary-gradient;
          border = mkLiteral theme.border;
          fg-col = mkLiteral "#cdd6f4";
          grey = mkLiteral "#6c7086";

          width = 600;
          font = "JetBrainsMono NF 14";
        };

        "element-text,element-icon,mode-switcher" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        window = {
          height = mkLiteral "360px";
          border = mkLiteral "2px";
          border-radius = mkLiteral "10px";
          border-color = mkLiteral "@primary";
          background-color = mkLiteral "@background";
          # background-image = mkLiteral "linear-gradient(45deg,${theme.primary},${theme.primary-gradient})";
          # padding = mkLiteral "4px";
        };

        mainbox = {
          background-color = mkLiteral "@background";
        };

        inputbar = {
          children = [
            (mkLiteral "prompt")
            (mkLiteral "entry")
          ];
          background-color = mkLiteral "@background";
          border-radius = mkLiteral "5px";
          padding = mkLiteral "2px";
        };

        prompt = {
          background-image = mkLiteral "linear-gradient(45deg,${theme.primary},${theme.primary-gradient})";
          padding = mkLiteral "6px";
          text-color = mkLiteral "@background";
          border-radius = mkLiteral "3px";
          margin = mkLiteral "20px 0px 0px 20px";
        };

        textbox-prompt-colon = {
          expand = false;
          str = ":";
        };

        entry = {
          padding = mkLiteral "6px";
          margin = mkLiteral "20px 0px 0px 10px";
          text-color = mkLiteral "@fg-col";
          background-color = mkLiteral "@background";
        };

        listview = {
          border = mkLiteral "0px 0px 0px";
          padding = mkLiteral "6px 0px 0px";
          margin = mkLiteral "10px 0px 0px 20px";
          columns = 2;
          lines = 5;
          background-color = mkLiteral "@background";
        };

        element = {
          padding = mkLiteral "5px";
          background-color = mkLiteral "@background";
          text-color = mkLiteral "@fg-col";
        };

        element-icon = {
          size = mkLiteral "25px";
        };

        "element selected" = {
          background-color = mkLiteral "@background";
          text-color = mkLiteral "@primary";
        };

        mode-switcher = {
          spacing = 0;
        };

        button = {
          padding = mkLiteral "10px";
          background-color = mkLiteral "@background";
          text-color = mkLiteral "@grey";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
        };

        "button selected" = {
          background-color = mkLiteral "@background";
          text-color = mkLiteral "@primary";
        };

        message = {
          background-color = mkLiteral "@background";
          margin = mkLiteral "2px";
          padding = mkLiteral "2px";
          border-radius = mkLiteral "5px";
        };

        textbox = {
          padding = mkLiteral "6px";
          margin = mkLiteral "20px 0px 0px 20px";
          text-color = mkLiteral "@primary";
          background-color = mkLiteral "@background";
        };
      };
    };
  };
}
