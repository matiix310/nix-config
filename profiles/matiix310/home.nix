{
  user,
  config,
  inputs,
  pkgs,
  configDir,
  ...
}:
let
  theme = import ../../themes/avalon.nix;
  monitor = "DP-1";
  ui_scale = 1.5;
in
{
  home.homeDirectory = "/home/${user.username}";
  home.username = user.username;

  imports = [
    ../../modules
  ];

  lang = {
    nix.enable = true;
  };

  hyprland = {
    enable = true;
    inherit theme;

    # to disable hyprlock
    # hyprlock.enable = false;
    # to install hyprlock from nixpkgs (bad idea)
    # hyprlock.nixPackage = true;

    # to disable hypridle
    # hypridle.enable = false;

    # to disable waybar
    # waybar.enable = false;
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
