{ ... }: {
  programs = {
    bat = {
      enable = true;
    };
    
    fd = {
      enable = true;
    };

    fzf = {
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    fastfetch = {
      enable = true;
      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        display = {
          size = {
            maxPrefix = "MB";
            ndigits = 0;
            spaceBeforeUnit = "never";
          };
          freq = {
            ndigits = 3;
            spaceBeforeUnit = "never";
          };
        };
        modules = [
          "title"
          "separator"
          "os"
          {
            type = "kernel";
            format = "{release}";
          }
          "uptime"
          {
            type = "packages";
            combined = true;
          }
          "shell"
          {
            type = "display";
            compactTpe = "original";
            key = "Resolution";
          }
          "de"
          "wm"
          "wmtheme"
          "theme"
          "icons"
          "terminal"
          {
            type = "terminalfont";
            format = "{/name}{-}{/}{name}{?size} {size}{?}";
          }
          "cpu"
          {
            type = "gpu";
            key = "GPU";
            format = "{name}";
          }
          {
            type = "memory";
            format = "{used} / {total}";
          }
          "break"
          "colors"
        ];
      };
    };

    lazygit = {
      enable = true;
    };
   
    starship = {
      enable = true;

      enableFishIntegration = true;
    };

    zoxide = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    zellij = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
    };
}
