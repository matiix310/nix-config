{
  pkgs,
  lib,
  config,
  ...
}:
let
  hyprcfg = config.hyprland;
  cfg = hyprcfg.waybar;
  theme = config.hyprland.theme;

  scripts = builtins.listToAttrs (
    builtins.map
      (script: {
        name = script;
        value = (pkgs.writeShellScript script (builtins.readFile (../../scripts/${script}.sh)));
      })
      [
        "hyprpicker-hex"
        "hyprpicker-rgb"
        "rofi-bluetooth"
        "rofi-wifi"
        "toggle-bluetooth"
        "toggle"
      ]
  );
in
{
  options.hyprland.waybar = {
    enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable waybar.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (hyprcfg.enable && cfg.enable) {

    home.packages = with pkgs; [
      playerctl
      hyprpicker
    ];

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          position = "top";
          layer = "top";
          height = 16;
          margin-top = 0;
          margin-bottom = -10;
          margin-left = 0;
          margin-right = 0;
          modules-left = [
            "group/group-stats"
            "hyprland/workspaces"
          ];
          modules-center = [ "custom/playerctl" ];
          modules-right = [
            "tray"
            "group/group-applets"
            "clock"
          ];

          # Modules configuration
          clock = {
            format = "{:%H:%M:%OS}";
            interval = 1;
            tooltip = false;
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%d/%m/%Y}";
            # on-click-right = "bash ~/.config/rofi/calendar/calendar.sh";
          };

          "hyprland/workspaces" = {
            format = "{icon}{windows}";
            format-window-separator = " ";
            window-rewrite-default = "󰧞";
            window-rewrite = {
              "class<zen> title<.*youtube.*>" = ""; # Windows whose titles contain "youtube"
              "class<zen> title<.*github.*>" = ""; # Windows whose class is "zen" and title contains "github". Note that "class" always comes first.
              "class<zen>" = ""; # Windows whose classes are "zen"
              "class<zen-beta>" = "󰖟";
              "class<kitty>" = "";
              "class<VSCodium>" = "󰨞";
              "class<codium-url-handler>" = "󰨞";
              "class<codium>" = "󰨞";
              "class<jetbrains-.*>" = "";
              "class<vesktop>" = "󰙯";
              "class<discord>" = "󰙯";
              "class<> title<(.* - .*)|(Spotify Free)>" = "󰓇";
              "class<.*youtube_music.*>" = "󰝚";
              "class<jetbrains-studio>" = "";
              "class<steam>" = "󰓓";
            };
            format-icons = {
              default = "";
              empty = "";
            };
          };

          "custom/playerctl" = {
            format = "{icon}   ::  <span>{0}</span>";
            return-type = "json";
            max-length = 64;
            exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
            on-click-middle = "playerctl play-pause";
            on-click = "playerctl previous";
            on-click-right = "playerctl next";
            format-icons = {
              Playing = "<span foreground='${config.theme.primary}'>󰝚</span>";
              Paused = "<span foreground='${config.theme.text-disabled}'>󰝛</span>";
            };
          };

          battery = {
            states = {
              good = 95;
              warning = 20;
              critical = 10;
            };
            format = "{icon}";
            format-charging = "󰂄";
            format-plugged = "󱐋";
            format-alt = "{icon} <span font='Iosevka'>{capacity}% | {time}</span>";
            # "format-good" = ""; // An empty format will hide the module
            # "format-full" = "";
            format-warning = "{icon} {capacity}% ({time})";
            format-critical = "{icon} {capacity}% ({time})";
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            interval = 5;
            tooltip-format = "{capacity}% - {time}";
          };

          memory = {
            states = {
              good = 60;
              warning = 80;
              critical = 90;
            };
            format = "{icon}";
            format-alt = "{used}GiB / {total}GiB";
            format-icons = [
              "󰪞"
              "󰪟"
              "󰪠"
              "󰪡"
              "󰪢"
              "󰪣"
              "󰪤"
              "󰪥"
            ];
            tooltip-format = "{used}GiB";
            interval = 5;
          };

          cpu = {
            format = "{usage}%";
            format-alt = "{avg_frequency}GHz";
            interval = 5;
          };

          disk = {
            format = "󰆼 {percentage_used}%";
            format-alt = "󰆼 {used} / {total}";
            interval = 20;
            path = "/";
          };

          "network#speed" = {
            format = " {bandwidthDownOctets}   {bandwidthUpOctets}";
            format-disconnected = ""; # An empty format will hide the module.
            max-length = 50;
            interval = 5;
          };

          temperature = {
            format = "{icon} {temperatureC}󰔄";
            format-alt = "{icon} {temperatureF}󰔅";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            critical-threshold = 40;
            tooltip = false;
          };

          network = {
            format-wifi = "󰤨";
            format-ethernet = "󰈀 {ifname}";
            format-linked = "󰈀 {ifname} (No IP)";
            format-disconnected = "󰤭";
            format-alt = "󰈀 {ifname} = {ipaddr}/{cidr}";
            tooltip-format = "{essid}";
            on-click-right = "bash ${scripts."rofi-wifi"}";
          };

          bluetooth = {
            format-on = "󰂯";
            format-off = "󰂲";
            format-connected = "󰂱";
            format-disabled = "󰂲";
            on-click = "bash ${scripts."toggle-bluetooth"}";
            on-click-right = "bash ${scripts."rofi-bluetooth"}";
            # "format-device-preference" = [ "device1" "device2" ]; # preference list deciding the displayed device
            tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
            tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          };

          "custom/notifications" = {
            tooltip = false;
            format = "{icon}";
            "format-icons" = {
              notification = "󰂚<span foreground='#DB4740'><sup></sup></span>";
              none = "󰂚";
              dnd-notification = "󰂛<span foreground='#DB4740'><sup></sup></span>";
              dnd-none = "󰂛";
              inhibited-notification = "󰂚<span foreground='#DB4740'><sup></sup></span>";
              inhibited-none = "󰂚";
              dnd-inhibited-notification = "󰂛<span foreground='#DB4740'><sup></sup></span>";
              dnd-inhibited-none = "󰂛";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };

          tray = {
            icon-size = 16;
            spacing = 5;
          };

          backlight = {
            # device = "acpi_video1";
            format = "{icon}";
            format-icons = [
              "󰃚"
              "󰃛"
              "󰃜"
              "󰃝"
              "󰃞"
              "󰃟"
              "󰃠"
            ];
            #	on-scroll-up =;
            #	on-scroll-down =;
            tooltip-format = "{percent}%";
          };

          pulseaudio = {
            format = "{icon}";
            format-muted = "󰝟";
            format-icons = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            on-click = "pamixer -t";
            on-click-right = "pwvucontrol";
            tooltip-format = "{volume}%";
          };

          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "󰒳";
              deactivated = "󰒲";
            };
            tooltip = false;
          };

          "custom/randwall" = {
            format = "󰏘";
            on-click = "nemo ~/Wallpapers/Selected";
            on-click-right = "nemo ~/Wallpapers";
          };

          # "custom/launcher" = {
          #   format = "󰢚";
          #   on-click = "bash ~/.config/rofi/launcher/launcher.sh";
          #   on-click-right = "bash ~/.config/rofi/powermenu/powermenu.sh";
          # };

          "custom/wf-recorder" = {
            format = "{}";
            interval = "once";
            exec = "echo ''";
            tooltip = false;
            exec-if = "pgrep 'wf-recorder'";
            on-click = "exec ./scripts/wlrecord.sh";
            signal = 8;
          };

          "custom/hyprpicker" = {
            format = "󰈋";
            on-click = "bash ${scripts."hyprpicker-hex"}";
            on-click-right = "bash ${scripts."hyprpicker-rgb"}";
            tooltip = false;
          };

          "group/group-applets" = {
            orientation = "inherit";
            modules = [
              "idle_inhibitor"
              "custom/hyprpicker"
              "bluetooth"
              "network"
              "pulseaudio"
              "backlight"
              "battery"
              "custom/notifications"
            ];
          };

          "group/group-stats" = {
            orientation = "inherit";
            modules = [
              "network#speed"
              "cpu"
              "memory"
              "disk"
              "temperature"
            ];
          };
        };
      };
      style = ''
        @define-color primary       ${config.theme.primary};
        @define-color secondary     ${config.theme.secondary};
        @define-color border        ${config.theme.border};
        @define-color text          ${config.theme.text};
        @define-color text-disabled ${config.theme.text-disabled};

        @define-color critical      ${config.theme.critical};
        @define-color warning       ${config.theme.warning};
        @define-color good          ${config.theme.good};
        @define-color background    ${config.theme.background};

        * {
          border: none;
          border-radius: 0px;
          font-size: 10pt;
          font-style: normal;
          min-height: 0;
        }

        window#waybar {
          background: transparent;
        }

        #workspaces button {
          color: @text-disabled;
        }

        #workspaces button.persistent {
          color: @text-disabled;
        }

        #workspaces button.active {
          color: @primary;
        }

        #workspaces button:hover {
          background: transparent;
          box-shadow: none;
          text-shadow: none;
          color: @primary;
        }

        #clock {
          font-weight: bold;
          color: @primary;
        }

        #custom-playerctl {
          font-weight: bold;
        }

        #idle_inhibitor.activated {
          color: @text-disabled;
        }

        #temperature,
        #custom-playerctl,
        #custom-hyprpicker,
        #bluetooth,
        #network,
        #pulseaudio,
        #backlight,
        #battery,
        #custom-notifications,
        #cpu,
        #memory,
        #disk,
        #idle_inhibitor {
          font-size: 10pt;
          margin: 0;
          padding: 0 10px;
          color: @text;
        }

        #bluetooth.connected {
          color: @primary;
        }

        #bluetooth.off {
          color: @text-disabled;
        }

        #pulseaudio.muted {
          color: @text-disabled;
        }

        #battery.charging {
          color: @good;
        }

        #battery.warning:not(.charging),
        #memory.warning {
          font-weight: bold;
          color: @warning;
        }

        #battery.critical:not(.charging),
        #memory.critical {
          font-weight: bold;
          color: @critical;
        }

        #custom-playerctl,
        #clock,
        #tray,
        #workspaces,
        #group-applets,
        #group-stats {
          background: @background;
          border: 2px solid @border;
          border-radius: 10px;
          padding: 3px 12px;
          margin: 5px 5px 10px 5px;
        }

        /* apply nerdfont to texts */
        #network.speed,
        #cpu,
        #disk,
        #temperature,
        #clock {
          font-family: "JetBrainsMono Nerd Font Mono";
        }
      '';
    };
  };
}
