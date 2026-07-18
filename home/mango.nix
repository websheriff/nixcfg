{ inputs, pkgs, ... }: {
  imports = [
    inputs.mangowm.hmModules.mango
  ];

  wayland.windowManager.mango = {
    enable = true;

    extraConfig = ''
      monitorrule=name:^DP-1$,width:3440,height:1440,refresh:164.900,x:1080,y:0,scale:1.0,vrr:0
      monitorrule=name:^DP-2$,width:1920,height:1080,refresh,165.00,x:0,y:0,scale:1.0,rr:1,vrr:0
    '';

    settings = {
      exec-once = [
        "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP"
        "systemctl --user import-environment PATH XDG_SESSION_TYPE XDG_SESSION_DESKTOP"
        "systemctl --user start mango-session.target"
      ];

      xwayland_persistence = 1;
      sloppyfocus = 1;

      # Window effects
      blur = 1;
      blur_optimized = 1;
      blur_params = {
        radius = 5;
        num_passes = 2;
      };

      focused_opacity = 1.0;
      unfocused_opacity = 0.9;

      border_radius = 12;
      borderpx = 4;

      animations = 1;
      animation_type_open = "slide";
      animation_type_close = "slide";

      new_is_master = 1;

      layerrule = [
        #No animations on DMS layers
        "noanim:1,layer_name:^dms"
      ];

      windowrule = [
        #Float DMS Windows
        "isfloating:1,appid:^org\.quickshell$"

        #Games
        #"isfullscreen:1,force_tearing:1,width:3440,height:1440,title:Path of Exile 2"

        #Send to second monitor
        "monitor:DP-2,appid:discord"
      ];

      bind = [
        #System Actions
        "SUPER,Return,spawn,ghostty"
        "SUPER,D,spawn,dms ipc call spotlight toggle"
        "SUPER,V,spawn,dms ipc call clipboard toggle"
        "SUPER,Comma,spawn,dms ipc call settings focusOrToggle"
        "SUPER,N,spawn,dms ipc call notifications toggle"
        "SUPER,M,spawn,dms ipc call processlist focusOrToggle"
        "SUPER,Y,spawn,dms ipc call dankdash wallpaper"
        "SUPER,L,spawn,swaylock"
        "SUPER,SPACE,toggleoverview"
        "SUPER+CTRL,R,reload_config"

        #Audio Controls
        "NONE,XF86AudioRaiseVolume,spawn,dms ipc call audio increment 3"
        "NONE,XF86AudioLowerVolume,spawn,dms ipc call audio decrement 3"
        "NONE,XF86AudioMute,spawn,dms ipc call audio mute"
        "NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        #Media Keys
        "NONE,XF86AudioPlay,spawn,playerctl play-pause"
        "NONE,XF86AudioStop,spawn,playerctl stop"
        "NONE,XF86AudioPrev,spawn,playerctl previous"
        "NONE,XF86AudioNext,spawn,playerctl next"

        #Brightness Control
        "NONE,XF86MonBrightnessUp,spawn,dms ipc call brightness increment 5"
        "NONE,XF86MonBrightnessDown,spawn,dms ipc call brightness decrement 5"

        #Windows
        "SUPER,Q,killclient"
        "SUPER,F,togglemaximizescreen"
        "SUPER+CTRL,F,togglefullscreen"
        "SUPER+ALT,F,togglefloating"
        "SUPER,S,switch_layout"

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
        "SUPER+ALT,Left,resizewin,-20,0"
        "SUPER+ALT,Right,resizewin,20,0"
        "SUPER+ALT,Up,resizewin,0,-20"
        "SUPER+ALT,Down,resizewin,0,20"

        # Screenshots
        "NONE,Print,spawn,grim -g \"$(slurp)\" $HOME/Pictures/Screenshots/Screenshot_$(date +%Y%m%d%H%M%S).png"
        "Ctrl,Print,spawn,grim $HOME/Pictures/Screenshots/Screenshot_$(date +%Y%m%d%H%M%S).png"
        "Alt,Print,spawn,grim save active"
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
      #QT_QPA_PLATFORMTHEME = "gtk3";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      SDL_VIDEODRIVER = "wayland,x11";
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland,x11";
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}
