{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      imports = [ ./flake-modules ];
      perSystem =
        { system
        , pkgs
        , self'
        , ...
        }:
        let
          nixvim' = inputs.nixvim.legacyPackages.${system};
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = import ./config { };
          };
          nvimLight = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = import ./config { darkMode = false; };
          };
        in
        {
          packages.default = nvim;
          packages.dark = nvim;
          packages.light = nvimLight;
        };
    };
}
