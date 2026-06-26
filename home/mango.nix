{ inputs, ... }: {
  imports = [
    inputs.mangowm.hmModules.mango
  ];

  wayland.windowManager.mango = {
    enable = true;

    autostart_sh = ''
      noctalia &
    '';

    extraConfig = ''
      monitorrule=name:^DP-1$,width:3440,height:1440,refresh:164.900,x:1080,y:0,scale:1.25,vrr:1
      monitorrule=name:^DP-2$,width:1920,height:1080,refresh,165.00,x:0,y:0,scale:1.0,rr:90,vrr:0
    '';

    settings = {
      xwayland_persistence = 1;
      sloppyfocus = 1;

      #monitor = [
      # "DP-1,width:3440,height:1440,refresh:164.900,x:1080,y:0,scale:1.25,vrr:1"
      # "DP-2,width:1920height:1080,refresh:165.000,x:0,y:0,scale:1.0,rr:90"
      #];

      # Window effects
      blur = 1;
      blur_optimized = 1;
      blur_params = {
        radius = 5;
        num_passes = 2;
      };

      focused_opacity = 1.0;
      unfocused_opacity = 0.94;

      border_radius = 6;

      animations = 1;
      animation_type_open = "slide";
      animation_type_close = "slide";

      bind = [
        #System Actions
        "SUPER,Return,spawn,ghostty"
        "SUPER,D,spawn,noctalia msg panel-toggle launcher"
        "SUPER,S,spawn,noctalia msg panel-toggle control-center"
        "SUPER,Comma,spawn,noctalia msg settings-toggle"
        "Super,L,spawn,swaylock"
        "SUPER,SPACE,toggleoverview"
        "SUPER+SHIFT,E,reload_config"

        #Audio Controls
        "NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up"
        "NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down"
        "NONE,XF86AudioMute,spawn,noctalia msg volume-mute"
        "NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        #Media Keys
        "NONE,XF86AudioPlay,spawn,playerctl play-pause"
        "NONE,XF86AudioStop,spawn,playerctl stop"
        "NONE,XF86AudioPrev,spawn,playerctl previous"
        "NONE,XF86AudioNext,spawn,playerctl next"

        #Brightness Control
        "NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up"
        "NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down"

        #Windows
        "SUPER,Q,killclient"
        "SUPER,F,togglefullscreen"
        "SUPER+CTRL,F,togglefloating"
        "SUPER,V,switch_layout"

        #Window Focus
        "SUPER,Left,focusdir,left"
        "SUPER,Right,focusdir,right"
        "SUPER,Up,focusdir,up"
        "SUPER,Down,focusdir,down"

        # Moving client position alignment windows
        "SUPER+SHIFT,Left,exchange_client,left"
        "SUPER+SHIFT,Right,exchange_client,right"
        "SUPER+SHIFT,Up,exchange_client,up"
        "SUPER+SHIFT,Down,exchange_client,down"

        #Focus Monitors
        "SUPER+CTRL,Left,focusmon,left"
        "SUPER+CTRL,Right,focusmon,right"

        #Switch Windows to Monitors
        "SUPER+SHIFT+CTRL,Left,tagmon,left"
        "SUPER+SHIFT+CTRL,Right,tagmon,right"

        #Tag-switching
        "SUPER,1,view,1"
        "SUPER,2,view,2"
        "SUPER,3,view,3"
        "SUPER,4,view,4"
        "SUPER,5,view,5"
        "SUPER,6,view,6"
        "SUPER,7,view,7"
        "SUPER,8,view,8"
        "SUPER,9,view,9"

        #Move windows across tags
        "SUPER+SHIFT,1,tag,1"
        "SUPER+SHIFT,2,tag,2"
        "SUPER+SHIFT,3,tag,3"
        "SUPER+SHIFT,4,tag,4"
        "SUPER+SHIFT,5,tag,5"
        "SUPER+SHIFT,6,tag,6"
        "SUPER+SHIFT,7,tag,7"
        "SUPER+SHIFT,8,tag,8"
        "SUPER+SHIFT,9,tag,9"

        #Prev/Next tag
        "SUPER,Prior,viewtoleft"
        "SUPER,Next,viewtoright"

        # Layout adjustments (Resizing windows)
        "SUPER,Minus,setmfact,-0.05"
        "SUPER,Equal,setmfact,+0.05"

        # Screenshots
        "NONE,Print,spawn,grimshot save area"
        "Ctrl,Print,spawn,grimshot save screen"
        "Alt,Print,spawn,grimshot save active"
      ];

      tagrule = [
        "id:1,monitor_name:DP-1,layout_name:tile"
        "id:2,monitor_name:DP-1,layout_name:scroller"
        "id:3,monitor_name:DP-1,layout_name:tile"
        "id:4,monitor_name:DP-1,layout_name:tile"
        "id:5,monitor_name:DP-1,layout_name:tile"
        "id:6,monitor_name:DP-1,layout_name:tile"
        "id:7,monitor_name:DP-1,layout_name:tile"
        "id:8,monitor_name:DP-1,layout_name:tile"
        "id:9,monitor_name:DP-1,layout_name:tile"

        "id:1,monitor_name:DP-2,layout_name:vertical_scroller"
        "id:2,monitor_name:DP-2,layout_name:vertical_scroller"
      ];
    };
  };

  home = {
    packages = with pkgs; [
      dbus
      cliphist
      wl-clipboard
      grim
      slurp
    ];

    sessionVariables = {
      XDG_SESSION_DESKTOP = "Mango";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland,x11";
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}
