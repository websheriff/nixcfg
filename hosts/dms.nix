{ inputs, pkgs, ... }: {
  imports = [
    inputs.dms-plugin-registry.nixosModules.default
    inputs.dms.nixosModules.greeter
  ];

  programs.dms-shell = {
    enable = true;
    package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;

    plugins = {
      dankKDEConnect.enable = true;
      discordVoice.enable = true;
    };
  };

  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "mango";
  };
}
