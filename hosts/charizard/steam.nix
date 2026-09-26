{ lib, pkgs, ... }: {

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;

      package = pkgs.steam.override {
        extraPkgs =
          pkgs': with pkgs'; [
            libXcursor
            libXi
            libXinerama
            libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib # Provides libstdc++.so.6
            libkrb5
            keyutils
          ];
      };
    };

    gamescope = {
      enable = true;
      #enableWsi = true;
      capSysNice = true;
    };

    gamemode.enable = true;
  };
}
