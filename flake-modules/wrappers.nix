{
  inputs,
  self,
  ...
}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    _module.args = {
      makeNixvimWithModule = import ../wrappers/standalone.nix pkgs self;
    };
  };

  flake = {
    homeManagerModules = {
      nixvim = import ../wrappers/hm.nix self;
      default = self.homeManagerModules.nixvim;
    };
    /*
    nixosModules = {
      nixvim = import ../wrappers/nixos.nix self;
      default = self.nixosModules.nixvim;
    };
    nixDarwinModules = {
      nixvim = import ../wrappers/darwin.nix self;
      default = self.nixDarwinModules.nixvim;
    };
    */
  };
}
