{ config, lib, ... }:
let
  termcfg = config.terminal;
  cfg = termcfg.starship;
in
{
  options.terminal.starship = {
    enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable Starship.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (termcfg.kitty.enable && cfg.enable) {
    programs.starship.enable = true;
    programs.starship.settings = {
      # Inserts a blank line between shell prompts
      add_newline = false;
      scan_timeout = 30;
      command_timeout = 300;

      # Replace the '❯' symbol in the prompt with '➜'
      character = {
        # The name of the module we are configuring is 'character'
        success_symbol = "[➜](bold green)"; # The 'success_symbol' segment is being set to '➜' with the color 'bold green'
        error_symbol = "[➜](bold red)";
      };

      # Disable the package module, hiding it from the prompt completely
      package = {
        disabled = true;
      };

      username = {
        style_user = "yellow bold";
        style_root = "black bold";
        format = "[$user]($style) ";
        disabled = false;
        show_always = true;
        aliases = {
          "lucas.stephan" = "Matiix310";
        };
      };

      status = {
        symbol = "";
        format = "[$symbol$status]($style) ";
        map_symbol = true;
        disabled = false;
      };

      battery = {
        discharging_symbol = "🦧 ";
      };

      sudo = {
        style = "bold green";
        symbol = "👩‍💻 ";
        disabled = false;
      };

      direnv = {
        format = "[$allowed]($style)";
        allowed_msg = "direnv  ";
        not_allowed_msg = "direnv  ";
        denied_msg = "direnv  ";
        disabled = false;
      };

      nix_shell = {
        symbol = "❄️ ";
      };

      directory = {
        fish_style_pwd_dir_length = 1;
        truncation_length = 0;
      };

      directory.substitutions = {
        "~/epita" = "[EPITA]";
        "~/perso" = "[PERSO]";
      };
    };
  };
}
