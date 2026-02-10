{
  user,
  config,
  inputs,
  pkgs,
  configDir,
  ...
}:
{
  home.homeDirectory = "/home/${user.username}";
  home.username = user.username;

  imports = [
    ../../modules
  ];

  theme = import ../../themes/avalon.nix;

  monitors = [
    "eDP-1,3072x1920@60, 0x0, 1.6"
    "HDMI-A-1,1920x1080@60, auto-center-up, 1"
    "DP-3, 1920x1080@60, auto-center-up, 1"
  ];

  kb_layout = "fr";

  lang = {
    nix.enable = true;
  };

  hyprland = {
    enable = true;

    # To diable swaync.
    # swaync.enable = false;

    # To diable chromium flags.
    # flags.chromium.enable = false;

    # To diable electron flags.
    # flags.electron.enable = false;

    # To disable hyprlock.
    # hyprlock.enable = false;

    # To disable hypridle.
    # hypridle.enable = false;

    # To disable waybar.
    # waybar.enable = false;
  };

  terminal = {
    kitty.enable = true;

    # To disable starship.
    # starship.enable = false;

    # You still need to install and setup fish as your default shell.
    # To disable fish plugins.
    # fish.enable = false;
  };

  # additional programs without custom config
  programs = {
    ranger.enable = true;
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
