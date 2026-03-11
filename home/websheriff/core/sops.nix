{  ... }: {

  sops = {
    age.keyFile = "/home/websheriff/.config/sops/age/keys.txt";

    defaultSopsFile = ../../../secrets.yaml;
    validateSopsFile = false;

  };
}
