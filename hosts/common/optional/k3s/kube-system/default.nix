{ ... }: {

  imports = [
    ./apps/traefik
    ./apps/nfd
    ./apps/intel-device-plugins-gpu
    ./apps/intel-device-plugins-operator
  ];
}
