{
  config,
  lib,
  pkgs,
  ...
}:
let
  termcfg = config.terminal;
  cfg = termcfg.fish;
in
{
  options.terminal.fish = {
    enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable Fish.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (termcfg.kitty.enable && cfg.enable) {
    programs.fish.enable = true;
    programs.fish.plugins = [
      {
        name = "nvm";
        src = pkgs.fishPlugins.nvm.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
    ];
    programs.fish.interactiveShellInit = ''
      # Commands to run in interactive sessions can go here

      # Load starship
      starship init fish | source

      # remove the greeting message
      set fish_greeting ""

      fish_add_path /usr/share/dotnet
      fish_add_path /usr/share/dotnet-old-versions
      fish_add_path /home/matiix310/.cargo/bin
      fish_add_path /home/matiix310/.local/bin

      # Android
      set -gx ANDROID_HOME "$HOME/Android/Sdk"
      fish_add_path "$ANDROID_HOME/emulator"
      fish_add_path "$ANDROID_HOME/platform-tools"

      # nvim
      set -gx VISUAL nvim
      set -gx EDITOR nvim

      # bun
      set -gx BUN_INSTALL "$HOME/.bun"
      fish_add_path "$BUN_INSTALL/bin"

      # direnv
      direnv hook fish | source

      # SDL
      set -gx SDL_VIDEODRIVER "wayland,x11"

      # Mounette
      set -gx MOUNETTE_TOKEN 1rCgZzBXnBSbgzsnvGXV

      # GDB
      alias gdb "gdb -q"

      # clear alias
      alias c="clear"

      # Directory Listing aliases
      alias ls 'ls --color=auto'
      alias l 'ls -lathF' # long, sort by newest to oldest
      alias la 'ls -Al' # show hidden files
      alias ll 'ls -l'

      # fix kitty with ssh
      alias ssh 'kitty +kitten ssh'

      # auto connect to wifi portals
      alias wifi-portal 'zen-browser "http://detectportal.firefox.com/canonical.html"'

      # pyenv
      pyenv init - | source

      # bat alias
      abbr cat bat

      # podman
      # set -gx PODMAN_COMPOSE_PROVIDER podman-compose
      set -gx DOCKER_BUILDKIT 1
      abbr docker podman
    '';
  };
}
