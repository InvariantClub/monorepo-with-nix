{ inputs, ... }:
with inputs; {
  perSystem = { pkgs, lib, system, ... }:
    let
      # Allow building with custom environment variables. Can be useful for
      # building a specific version for deployment.
      mkFrontend = envVars: pkgs.buildNpmPackage {
        pname = "fe";
        version = "0.0.0";

        src = lib.cleanSource ../.;

        npmDeps = pkgs.importNpmLock { npmRoot = lib.cleanSource ../.; };

        npmConfigHook = pkgs.importNpmLock.npmConfigHook;

        doCheck = true;

        preBuild = ''
        '';

        buildPhase = with lib.strings; ''
          ${stringAsChars (x: if x == "\n" then " " else x) (toShellVars envVars)} npm run build
        '';

        checkPhase = ''
          npm run test:unit
        '';

        installPhase = ''
          mkdir $out
          cp -r dist/* $out
        '';
      };
    in
    {
      # Usage:
      #
      # > nix build .#frontend
      # > miniserve result/
      #
      packages.frontend = mkFrontend {
        VITE_API_HOST = "localhost";
        VITE_API_PORT = "3030";
      };

      devShells.frontend = pkgs.mkShell {
        packages = with pkgs; [
          miniserve
          nodejs
        ];
      };
    };
}
