{ config, ... }:

let
  dataDir = "/home/${config.home.aiRunner}/containers/ollama"
in 
{
  services.podman.containers.ollama = {
    image = "docker.io/ollama/ollama";
    autoStart = true;
    autoUpdate = true;

    ports = [ "11434:11434" ];
    volumes = [ "${dataDir}:/root/.ollama" ];
  }; 
}
