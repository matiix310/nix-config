{
  config,
  lib,
  pkgs,
  ...
}:
let
  termcfg = config.terminal;
  cfg = termcfg.fish;

  appendIfTrue = condition: str: if condition then str else "";
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
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
    ];
    programs.fish.interactiveShellInit = ''
      # remove the greeting message
      set fish_greeting ""

      fish_add_path "$HOME/.cargo/bin"
      fish_add_path "$HOME/.local/bin"

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
      command -v direnv >/dev/null && direnv hook fish | source

      # SDL
      set -gx SDL_VIDEODRIVER "wayland,x11"

      # GDB
      alias gdb "gdb -q"

      # clear alias
      alias c="clear"

      # mkcd
      function mkcd --description "mkdir && cd"
        mkdir -p $argv[1]
        cd $argv[1]
      end

      # Directory Listing aliases
      alias ls 'ls --color=auto'
      alias l 'ls -lathF' # long, sort by newest to oldest
      alias la 'ls -Al' # show hidden files
      alias ll 'ls -l'

      ${appendIfTrue config.terminal.kitty.enable ''
        # fix kitty with ssh
        alias ssh 'kitty +kitten ssh'
        set -gx TERM kitty
      ''}

      # auto connect to wifi portals
      alias wifi-portal 'zen-browser "http://detectportal.firefox.com/canonical.html"'

      # pyenv
      pyenv init - | source

      # bat alias
      command -v bat >/dev/null && abbr cat bat

      # podman
      # command -v podman >/dev/null
      # if test $status -eq 0
      #   # set -gx PODMAN_COMPOSE_PROVIDER podman-compose
      #   set -gx DOCKER_BUILDKIT 1
      #   abbr docker podman
      # end
    '';
  };
}
