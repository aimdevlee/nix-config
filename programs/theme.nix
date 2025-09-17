# Theme and appearance configuration
{
  config,
  ...
}:
let
  # Catppuccin Mocha color palette
  catppuccinMocha = {
    name = "catppuccin-mocha";
    colors = {
      # Base colors
      rosewater = "#f5e0dc";
      flamingo = "#f2cdcd";
      pink = "#f5c2e7";
      mauve = "#cba6f7";
      red = "#f38ba8";
      maroon = "#eba0ac";
      peach = "#fab387";
      yellow = "#f9e2af";
      green = "#a6e3a1";
      teal = "#94e2d5";
      sky = "#89dceb";
      sapphire = "#74c7ec";
      blue = "#89b4fa";
      lavender = "#b4befe";

      # Surface colors
      text = "#cdd6f4";
      subtext1 = "#bac2de";
      subtext0 = "#a6adc8";
      overlay2 = "#9399b2";
      overlay1 = "#7f849c";
      overlay0 = "#6c7086";
      surface2 = "#585b70";
      surface1 = "#45475a";
      surface0 = "#313244";

      # Background colors
      base = "#1e1e2e";
      mantle = "#181825";
      crust = "#11111b";
    };
  };

in
{
  config = {
    # Make theme available to other modules
    home.sessionVariables = {
      THEME_NAME = catppuccinMocha.name;
    };

    # Theme colors are now used by Oh My Posh configuration
    # The color values are integrated directly into the Oh My Posh theme JSON
  };
}
