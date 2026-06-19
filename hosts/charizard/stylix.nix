{ inputs, pkgs, ... }: {

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/black-metal-bathory.yaml";

    cursor = {
      size = 16;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };

    autoEnable = true;
  };
}
