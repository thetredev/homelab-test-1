{
  description = "Homelab NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ... }@inputs:
  let
    nodes = [
      {
        name = "gitlab-runner";
        hostname = "gitlab-runner-nix";
        machine = "gitlab-runner";
      }
    ];
  in {
    nixosConfigurations = builtins.listToAttrs (map (node: {
	    name = node.name;
	    value = nixpkgs.lib.nixosSystem {
        specialArgs = {
          meta = node;
        };
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./disk.nix
          ./configuration.nix
        ];
      };
    }) nodes);
  };
}
