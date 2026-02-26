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
          # Just import any .nix file we find in the entire source tree;
          # skipping the flake.nix itself.
          #
          # Note that you could do this explicitly, if you preferred:
          #
          # inputs.import-tree [
          #   ./nix
          #   ./analytics/nix
          #   ...
          #   ]
          (inputs.import-tree.filter (p: p != "/flake.nix") ./.)
        ];
      };
}
