{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.hyprland;
  theme = config.theme;
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
    home.packages = with pkgs; [
      hyprpaper
    ];

    xdg.portal.config.common.default = "*";

    # hyprland
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      settings = {
        "$inactive" = "0xff" + (lib.strings.removePrefix "#" theme.inactive);
        "$primary" = "0xff" + (lib.strings.removePrefix "#" theme.primary);
        "$primary-gradient" = "0xff" + (lib.strings.removePrefix "#" theme.primary-gradient);
        monitor = [
          ",preferred,auto,1"
          "Unknown-1, disable"
        ]
        ++ config.monitors;
        # monitor=HDMI-A-1,1920x1080@60, 3072x0, 1
        # monitor=,highres,auto,1.6
        # monitor=HDMI-A-1,1920x1080@60, -1920x0, 1

        # toolkit-specific scale
        # env = ELM_SCALE,1
        # env = GDK_SCALE,1
        env = [
          "XCURSOR_SIZE,24"
          # electron flag to run on wayland
          "ELECTRON_OZONE_PLATFORM_HINT,wayland"
          # enable wayland for Qt
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_SCALE_FACTOR_ROUNDING_POLICY,RoundPreferFloor"
        ];

        # See https://wiki.hyprland.org/Configuring/Keywords/ for more

        exec-once = [
          # Execute at launch.
          # The commands not available wont be a probleme
          "systemctl --user start hyprpolkitagent"
          "hyprsunset"
          "waybar"
          "hyprpaper"
          "swaync"
          "hypridle"
        ];

        # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
        input = {
          kb_layout = config.kb_layout;
          kb_variant = "";
          kb_model = "";
          kb_options = "grp:alt_shift_toggle";
          kb_rules = "";

          follow_mouse = 1;

          touchpad = {
            natural_scroll = "yes";
          };

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        };

        # unscale XWayland
        xwayland = {
          force_zero_scaling = true;
        };

        general = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          gaps_in = 5;
          gaps_out = 5;
          border_size = 2;
          "col.active_border" = "$primary $primary-gradient 45deg";
          "col.inactive_border" = "$inactive";

          layout = "dwindle";
        };

        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          active_opacity = 0.9;
          inactive_opacity = 0.7;
          fullscreen_opacity = 1.0;
          rounding = 10;

          blur = {
            enabled = true;
            size = 8;
            new_optimizations = true;
          };
        };

        animations = {
          enabled = "yes";

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "windowsMove, 1, 7, default"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = "yes"; # you probably want this
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_status = "master";
        };

        misc = {
          vfr = true;
          disable_hyprland_logo = true; # :'(
        };

        # Example windowrule v1
        # windowrule = float, ^(kitty)$
        # Example windowrule v2
        # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
        windowrulev2 = [
          "opacity 1.0 override, class:^firefox$"
          "opacity 1.0 override, class:^zen$"
          "opacity 1.0 override, class:^(jetbrains-(?!toolbox).*)$"
          "tile, class:^(jetbrains-(?!toolbox).*)$"
          "float, class:^(jetbrains-(?!toolbox).*)$, title:^(win[0-9]*)$"
          "nofocus, class:^(jetbrains-(?!toolbox).*)$, title:^(win[0-9]*)$"
          "move 10 60, title:^(JetBrains Toolbox)$"

          # Display neofetch in a custom window
          "size 900 450, class:neofetch"
          "float, class:neofetch"
          "opacity 1.0 override, class:neofetch"

          # Rules to enable screensharing between X and Wayland apps
          "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
          "maxsize 1 1,class:^(xwaylandvideobridge)$"
          "noblur,class:^(xwaylandvideobridge)$"
        ];

        # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        "$mainMod" = "SUPER";

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = [
          "$mainMod, Q, exec, kitty"
          "$mainMod SHIFT, Q, exec, kitty --class neofetch -T neofetch --detach sh -c \"neofetch; read\""
          "$mainMod, F, exec, zen-browser"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit, 0"
          "$mainMod, E, exec, thunar"
          "$mainMod, V, togglefloating,"
          "$mainMod, B, pin,"
          "$mainMod, R, exec, wofi --show drun"
          "$mainMod, P, pseudo," # dwindle
          "$mainMod, J, togglesplit," # dwindle
          "$mainMod, L, exec, hyprlock" # lock the screen
          "$mainMod, A, exec, rofi -show drun" # open the app search engine
          "$mainMod, X, fullscreen"

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, ampersand, workspace, 1"
          "$mainMod, eacute, workspace, 2"
          "$mainMod, quotedbl, workspace, 3"
          "$mainMod, apostrophe, workspace, 4"
          "$mainMod, parenleft, workspace, 5"
          "$mainMod, minus, workspace, 6"
          "$mainMod, egrave, workspace, 7"
          "$mainMod, underscore, workspace, 8"
          "$mainMod, ccedilla, workspace, 9"
          "$mainMod, agrave, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, ampersand, movetoworkspace, 1"
          "$mainMod SHIFT, eacute, movetoworkspace, 2"
          "$mainMod SHIFT, quotedbl, movetoworkspace, 3"
          "$mainMod SHIFT, apostrophe, movetoworkspace, 4"
          "$mainMod SHIFT, parenleft, movetoworkspace, 5"
          "$mainMod SHIFT, minus, movetoworkspace, 6"
          "$mainMod SHIFT, egrave, movetoworkspace, 7"
          "$mainMod SHIFT, underscore, movetoworkspace, 8"
          "$mainMod SHIFT, ccedilla, movetoworkspace, 9"
          "$mainMod SHIFT, agrave, movetoworkspace, 10"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          # Screenshot (for some reason S = "Impéc key)
          "$mainMod SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy"

          # Notification
          "$mainMod SHIFT, N, exec, swaync-client -t -sw"
        ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        binde = [
          # Volume control
          ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
          ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
          ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
          ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"

          # Brightness control
          ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
          ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"

          # Screenshot (for some reason S = "Impéc key)
          "$mainMod, S, exec, grim -g \"$(slurp)\""
        ];

        gesture = [
          # Swipe gesture
          "3, horizontal, workspace"
        ];
      };
    };

    # wallpaper
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
