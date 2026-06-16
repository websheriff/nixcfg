{
	description = "Nixcfg Flake";
	inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
		nixpkgs.url = "nixpkgs/nixos-26.05";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    preservation.url = "github:nix-community/preservation";
		home-manager = {
			url = "github:nix-community/home-manager/release-26.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		sops-nix = {
		  url = "github:Mic92/sops-nix";
		  inputs.nixpkgs.follows = "nixpkgs";
		};
    flake-parts.url = "github:hercules-ci/flake-parts";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	};

	outputs = {
	  self,
	  sops-nix,
	  flake-parts,
	  nixpkgs,
	  nixpkgs-unstable,
	  disko,
	  impermanence,
	  home-manager,
	  ... }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        charizard = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/charizard
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
          ];
        };
      };
		  nixosConfigurations = {
			  kanto = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
			    modules = [
				    ./hosts/kanto
            sops-nix.nixosModules.sops
			    ];
		    };
	    };
      nixosConfigurations = {
	      snorlax = nixpkgs.lib.nixosSystem {
	        specialArgs = { inherit inputs outputs; };
	        modules = [
		        ./hosts/snorlax
		        disko.nixosModules.disko
		        sops-nix.nixosModules.sops
          ];
        };
      };
      nixosConfigurations = {
        sevii01 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/sevii01
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
