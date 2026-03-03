let
  kanto = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZmR0urfmBXLlJgQj2mMI5cEwrj5b0Ny5msoJx/Gi3x";
in {
  "secret1.age".publicKeys = [ kanto ];
}
