{ config, pkgs, ... }: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    host = "0.0.0.0";
    openFirewall = true;
    environmentVariables = {
      CUDA_VISIBLE_DEVICES = "0";
    };
  };

  environment.etc."llama-swap/config.yaml".text = ''
    models:

      #Qwen3.5-9b
      "qwn3.5-9b-gguf":
          cmd: |
            ${pkgs.llama-ccp}/bin/llama-server
            -hf unsloth/Qwen3.5-9B-GGUF:Qwen3.5-9B-Q8_0.gguf \
            --port ''${PORT}
            --ctx-size 32768
            --gpu-layer 999 \
            --temp 0.7 \
            --top-p 0.8 \
            --top-k 20 \
            --min-p 0.05
            --jinja \
            --chat-template-kwargs '{"enable_thinking":true}'

    healthCheckTimeout: 600

    ttl: 1300 # Keep loaded 30 minutes

    groups:
      # always keep loaded
      embedding:
        persistent: true
        swap: false
        exclusive: false
        members:
  '';

  systemd.services.llama-swap = {
    description = "llama-swap - OpenAI compatible proxy with automatic model swapping";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = "llamaccp";
      Group = "users";
      ExecStart = "${pkgs.llama-swap}/bin/llama-swap --config /etc/llama-swap/config.yaml --listen 0.0.0.0:8000 --watch-config";
      Restart = "always";
      RestartSec = 10;
      # CUDA
      Environment = [
        "PATH=/run/current-system/sw/bin"
        "LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib"
        # llama-swap can use both GPUs, Ollama is restricted to GPU 0
      ];
      PrivateTmp = true;
      NoNewPrivileges = true;
    };
  };

  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;

    settings = {
      model = {
        default = "qwen3.5-9b-gguf";
        base_url = "http://127.0.0.1:8000/v1";
      };

      display = {
        compact = false;
        personality = "concise";
      };

      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
      };
    };
  };

  users.users.llamacpp = {
    isSystemUser = true;
    group = "llamacpp";
    createHome = true;
    home = "/srv/llamacpp";
  };
}
