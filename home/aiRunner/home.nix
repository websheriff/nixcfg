{ config, pkgs, ...}: {

home.username = "aiRunner";
home.homeDirectory = "/home/aiRunner";
home.stateVersion = "25.11";

services.podman = { 
  enable = true; 
  autoPrune.enable;
};

imports = [
  
];

}
