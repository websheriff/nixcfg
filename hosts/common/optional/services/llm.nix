{ pkgs, ... }: {
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

        #Qwen3.5-35b non-thinking for Vane search
        "qwn3.5-35b-a3b-gguf":
            cmd: |
              ${pkgs.llama-ccp}/bin/llama-server
              -hf unsloth/Qwen3-35B-A3B-GGUF:UD-Q4_K_XL \
              --port ''${PORT}
              --ctx-size 16384
              --temp 0.7 \
              --top-p 0.8 \
              --top-k 20 \
              --min-p 0.00
              --chat-template-kwargs '{"enable_thinking":false}'

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
        User = "websheriff";
        Group = "users";
        ExecStart = "${pkgs.llama-swap}/bin/llama-swap --config /etc/llama-swap/config.yaml --listen 0.0.0.0:9292 --watch-config";
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
  }
