{ inputs, ... }: {
  perSystem = { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ ];
      };
    in
    {
      _module.args = { inherit pkgs; };
    };
}
