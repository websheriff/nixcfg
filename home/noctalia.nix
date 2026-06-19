{ inputs, ... }: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  stylix.targets.noctalia-shell.enable = true;

  programs.noctalia = {
    enable = true;

    settings = {
      shell = {
        panel = {
          transparency_mode = "glass";
          control_center_placement = "attached";
        };
      };
      bar.default = {
        monitor.dp2 = {
          match = "DP-2";
          enabled = false;
        };

        position = "top";
        margin_edge = 0;

        start = [
          "launcher"
          "workspaces"
          "active_window"
        ];
        center = [
          "clock"
        ];
        end = [
          "media"
          "tray"
          "notifications"
          "bluetooth"
          "network"
          "volume"
          "sysmon"
          "control-center"
          "session"
        ];
      };

      widget = {
        launcher = {
          glyph = "search";
        };

        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
        };

        temp = {
          type = "sysmon";
          stat = "cpu_temp";
        };

        ram = {
          type = "sysmon";
          stat = "ram_used";
        };
      };

      theme = {
        source = "custom";
        custom_palette = "stylix";
        mode = "dark";
        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };

      osd = {
        position = "top_right";
        orientation = "horizontal";
        monitors = [ "DP-1" ];
      };
    };
  };
}
