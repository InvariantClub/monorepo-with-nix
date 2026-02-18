{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    import-tree.url = "github:vic/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";

    # Python inputs
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rust
    crane.url = "github:ipetkov/crane";

  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      {
        systems = [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ];

        imports = [
          inputs.process-compose-flake.flakeModule

          (inputs.import-tree ./nix)
          (inputs.import-tree ./analytics/nix)
          (inputs.import-tree ./frontend/nix)
          (inputs.import-tree ./backend/nix)
          (inputs.import-tree ./infra/nix)
        ];
      };
}
