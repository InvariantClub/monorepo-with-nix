{ inputs, ... }:
with inputs; {
  perSystem =
    { pkgs
    , lib
    , system
    , ...
    }:
    let
      # Following: https://crane.dev/getting-started.html
      craneLib = crane.mkLib pkgs;

      commonArgs = {
        src = craneLib.cleanCargoSource ../.;
        strictDeps = true;

        buildInputs = [
          # Add additional build inputs here
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          pkgs.libiconv
        ];
      };

      backend = craneLib.buildPackage (
        commonArgs
        // {
          cargoArtifacts = craneLib.buildDepsOnly commonArgs;
        }
      );
    in
    {
      packages.backend = backend;
      devShells.backend = craneLib.devShell {
        packages = with pkgs; [ ];
      };
    };
}
