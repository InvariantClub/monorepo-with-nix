{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { pkgs, lib, ... }:
    {
      treefmt = {
        # JS
        programs.prettier.enable = true;
        # Nix
        programs.nixpkgs-fmt.enable = true;
        # Rust
        programs.rustfmt.enable = true;
        # Python
        programs.ruff.format = true;
        programs.ruff.check = true;
      };
    };
}
