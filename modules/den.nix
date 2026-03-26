{ inputs, den, lib, ... }: {

  imports = [
    inputs.den.flakeModule
  ];

  den.schema.user.classes = lib.mkDefault [ "homeManger" ];

  den.default.homeManager.home.stateVersion = "25.11";
}
