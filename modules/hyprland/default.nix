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
    ./flags.nix
    ./swaync.nix
  ];

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpaper
    ];

    # xdg.portal.config.common.default = "*";

    home.file = {
        ".config/hypr/hyprland.conf".text = ''
            $inactive = 0xff${lib.strings.removePrefix "#" theme.inactive}
            $primary = 0xff${lib.strings.removePrefix "#" theme.primary}
            $primary_gradient = 0xff${lib.strings.removePrefix "#" theme.primary-gradient}

            # See https://wiki.hyprland.org/Configuring/Monitors/
            monitor = ,preferred,auto,1
            # disable unknown monitor
            monitor = Unknown-1, disable
            ${lib.concatStringsSep "\n" (map (m: "monitor = ${m}") config.monitors)}

            # toolkit-specific scale
            # env = ELM_SCALE,1
            # env = GDK_SCALE,1
            env = XCURSOR_SIZE,24

            # electron flag to run on wayland
            env = ELECTRON_OZONE_PLATFORM_HINT,wayland

            # enable wayland for Qt
            env = QT_QPA_PLATFORM,wayland;xcb
            env = QT_SCALE_FACTOR_ROUNDING_POLICY,RoundPreferFloor

            # See https://wiki.hyprland.org/Configuring/Keywords/ for more

            # Execute your favorite apps at launch
            exec-once = systemctl --user start hyprpolkitagent
            exec-once = hyprsunset
            exec-once = waybar & fcitx
            exec-once = lxsession
            # This will make sure that xdg-desktop-portal-hyprland can get the required variables on startup.
            exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
            # exec-once = swaybg -m fill -i /home/matiix310/.config/hypr/background.png
            # exec-once = ~/.config/hypr/choose_wallpaper.sh | xargs swaybg -m fill -i
            exec-once = hyprpaper
            exec-once = swaync
            exec-once = hypridle

            source = ~/.config/hypr/mocha.conf

            # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
            input {
                kb_layout = fr
                kb_variant =
                kb_model =
                kb_options = grp:alt_shift_toggle
                kb_rules =

                follow_mouse = 1

                touchpad {
                    natural_scroll = yes
                }

                sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
            }

            # unscale XWayland
            xwayland {
                force_zero_scaling = true
            }

            general {
                # See https://wiki.hyprland.org/Configuring/Variables/ for more

                gaps_in = 5
                gaps_out = 5
                border_size = 2
                col.active_border = $primary $primary_gradient 45deg
                col.inactive_border = $inactive

                layout = dwindle
            }

            decoration {
                # See https://wiki.hyprland.org/Configuring/Variables/ for more

                active_opacity = 0.9
                inactive_opacity = 0.7
                fullscreen_opacity = 1.0
                rounding = ${builtins.toString theme.roundness}

                shadow {
                    enabled = false
                }

                blur {
                    enabled = true # OPTI: false
                    size = 8
                    # passes = 1
                    new_optimizations = true
                }

                # drop_shadow = false
                # shadow_range = 4
                # shadow_render_power = 3
                # col.shadow = rgba(1a1a1aee)
            }

            animations {
                enabled = yes # OPTI: no

                # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

                bezier = myBezier, 0.05, 0.9, 0.1, 1.05

                animation = windows, 1, 7, myBezier
                animation = windowsOut, 1, 7, default, popin 80%
                animation = border, 1, 10, default
                animation = borderangle, 1, 8, default
                animation = fade, 1, 7, default
                animation = workspaces, 1, 6, default
            }

            dwindle {
                # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
                pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
                preserve_split = yes # you probably want this
            }

            master {
                # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
                new_status = master
            }

            misc {
                vfr = true
                disable_hyprland_logo = true # :'(
            }

            # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
            windowrule = opacity 1.0 override, match:class ^firefox$
            windowrule = opacity 1.0 override, match:class ^zen$
            windowrule = opacity 1.0 override, match:class ^(jetbrains-(?!toolbox).*)$
            windowrule = tile on, match:class ^(jetbrains-(?!toolbox).*)$
            windowrule = float on, match:class ^(jetbrains-(?!toolbox).*)$, match:title ^(win[0-9]*)$
            windowrule = no_focus on, match:class ^(jetbrains-(?!toolbox).*)$, match:title ^(win[0-9]*)$
            windowrule = move 10 60, match:title ^(JetBrains Toolbox)$

            # Display neofetch in a custom window
            windowrule = size 900 450, match:class neofetch
            windowrule = float on, match:class neofetch
            windowrule = opacity 1.0 override, match:class neofetch

            # Rules to enable screensharing between X and Wayland apps
            windowrule = opacity 0.0 override 0.0 override, match:class ^(xwaylandvideobridge)$
            windowrule = no_anim on, match:class ^(xwaylandvideobridge)$
            windowrule = no_initial_focus on, match:class ^(xwaylandvideobridge)$
            windowrule = max_size 1 1, match:class ^(xwaylandvideobridge)$
            windowrule = no_blur on, match:class ^(xwaylandvideobridge)$

            # See https://wiki.hyprland.org/Configuring/Keywords/ for more
            $mainMod = SUPER

            # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
            bind = $mainMod, Q, exec, kitty
            bind = $mainMod SHIFT, Q, exec, kitty --class neofetch -T neofetch --detach sh -c "neofetch; read"
            bind = $mainMod, F, exec, zen-browser
            bind = $mainMod, C, killactive,
            bind = $mainMod, M, exit, 0
            bind = $mainMod, E, exec, thunar
            bind = $mainMod, V, togglefloating,
            bind = $mainMod, B, pin,
            bind = $mainMod, R, exec, wofi --show drun
            bind = $mainMod, P, pseudo, # dwindle
            bind = $mainMod, J, togglesplit, # dwindle
            bind = $mainMod, L, exec, hyprlock # lock the screen
            bind = $mainMod, A, exec, rofi -show drun # open the app search engine
            bind = $mainMod, X, fullscreen
            # bind = $mainMod, D, exec, /home/matiix310/perso/rust/smart-lock/target/release/smart-lock

            # Move focus with mainMod + arrow keys
            bind = $mainMod, left, movefocus, l
            bind = $mainMod, right, movefocus, r
            bind = $mainMod, up, movefocus, u
            bind = $mainMod, down, movefocus, d

            # Switch workspaces with mainMod + [0-9]
            bind = $mainMod, ampersand, workspace, 1
            bind = $mainMod, eacute, workspace, 2
            bind = $mainMod, quotedbl, workspace, 3
            bind = $mainMod, apostrophe, workspace, 4
            bind = $mainMod, parenleft, workspace, 5
            bind = $mainMod, minus, workspace, 6
            bind = $mainMod, egrave, workspace, 7
            bind = $mainMod, underscore, workspace, 8
            bind = $mainMod, ccedilla, workspace, 9
            bind = $mainMod, agrave, workspace, 10

            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            bind = $mainMod SHIFT, ampersand, movetoworkspace, 1
            bind = $mainMod SHIFT, eacute, movetoworkspace, 2
            bind = $mainMod SHIFT, quotedbl, movetoworkspace, 3
            bind = $mainMod SHIFT, apostrophe, movetoworkspace, 4
            bind = $mainMod SHIFT, parenleft, movetoworkspace, 5
            bind = $mainMod SHIFT, minus, movetoworkspace, 6
            bind = $mainMod SHIFT, egrave, movetoworkspace, 7
            bind = $mainMod SHIFT, underscore, movetoworkspace, 8
            bind = $mainMod SHIFT, ccedilla, movetoworkspace, 9
            bind = $mainMod SHIFT, agrave, movetoworkspace, 10

            # Scroll through existing workspaces with mainMod + scroll
            bind = $mainMod, mouse_down, workspace, e+1
            bind = $mainMod, mouse_up, workspace, e-1

            # Move/resize windows with mainMod + LMB/RMB and dragging
            bindm = $mainMod, mouse:272, movewindow
            bindm = $mainMod, mouse:273, resizewindow

            # Volume control
            binde = , XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%
            binde = , XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%
            binde = , XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle
            binde = , XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle

            # Brightness control
            binde = , XF86MonBrightnessUp, exec, brightnessctl set 10%+
            binde = , XF86MonBrightnessDown, exec, brightnessctl set 10%-

            # Screenshot (for some reason S = Impéc key)
            binde = $mainMod, S, exec, grim -g "$(slurp)"
            bind = $mainMod SHIFT, S, exec, grim -g "$(slurp)" - | wl-copy

            # Notification
            bind = $mainMod SHIFT, N, exec, swaync-client -t -sw

            # Swipe gesture
            gesture = 3, horizontal, workspace
        '';
    };

    # wallpaper
    home.file = {
      ".config/hypr/hyprpaper.conf".text = ''
        preload = ${theme.wallpaper}
        # If more than one preload is desired then continue to preload other backgrounds
        # preload = /path/to/next_image.png
        # ... more preloads

        # Set the default wallpaper(s) seen on initial workspace(s) --depending on the number of monitors used
        wallpaper = ,${theme.wallpaper}
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
