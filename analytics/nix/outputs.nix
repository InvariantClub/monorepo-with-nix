{ inputs, ... }:
with inputs; {
  perSystem = { pkgs, lib, system, ... }:
    let
      # Python setup
      workspace = uv2nix.lib.workspace.loadWorkspace {
        workspaceRoot = ../.;
      };
      overlay = workspace.mkPyprojectOverlay {
        sourcePreference = "wheel";
      };
      editableOverlay = workspace.mkEditablePyprojectOverlay {
        root = "$REPO_ROOT";
      };

      pythonSets =
        let
          version = lib.replaceString "." "" (lib.trim (builtins.readFile ../.python-version));
          python = pkgs."python${version}";
        in
        (pkgs.callPackage pyproject-nix.build.packages {
          inherit python;
        }).overrideScope
          (
            lib.composeManyExtensions [
              pyproject-build-systems.overlays.wheel
              overlay
              (
                final: prev:
                  let
                    inherit (final) resolveBuildSystem;
                    inherit (builtins) mapAttrs;
                    buildSystemOverrides = { };
                  in
                  mapAttrs
                    (
                      name: spec:
                        prev.${name}.overrideAttrs (old: {
                          nativeBuildInputs = old.nativeBuildInputs ++ resolveBuildSystem spec;
                        })
                    )
                    buildSystemOverrides
              )
            ]
          );

      pythonSet = pythonSets.overrideScope editableOverlay;
      virtualenv = pythonSet.mkVirtualEnv "dev-venv" workspace.deps.all;

      pythonDistSet = pythonSets.overrideScope overlay;

      inherit (pkgs.callPackages pyproject-nix.build.util { }) mkApplication;

      addMeta = p: drv:
        drv.overrideAttrs (old: {
          passthru = lib.recursiveUpdate (old.passthru or { }) {
            inherit (pythonSet.testing.passthru) tests;
          };

          meta =
            (old.meta or { })
            // {
              # Corresponds to the [script] entrypoint
              mainProgram = p;
            };
        });
    in
    {
      # An entrypoint to run the 'compute' script from anywhere.
      packages.analytics-compute = addMeta "compute" (mkApplication {
        venv = pythonDistSet.mkVirtualEnv "app-env" workspace.deps.all;
        package = pythonDistSet.analytics-stuff;
      });

      devShells.python = pkgs.mkShell {
        packages = [
          virtualenv
          pkgs.uv
          pkgs.ruff
        ];
        env = {
          UV_NO_SYNC = "1";
          UV_PYTHON = pythonSet.python.interpreter;
          UV_PYTHON_DOWNLOADS = "never";
        };
        # Note: We explicitly set the REPO_ROOT below to the present
        # working directory.
        shellHook = ''
          unset PYTHONPATH
          export REPO_ROOT=$(git rev-parse --show-toplevel)/analytics
        '';
      };
    };
}
