{ inputs, ... }: {
  perSystem =
    { pkgs
    , lib
    , system
    , self'
    , ...
    }:
    {
      packages.backend-image = pkgs.dockerTools.streamLayeredImage {
        name = "monorepo-with-nix-${self'.packages.backend.pname}";
        tag = "latest";
        created = "now";
        contents = [ self'.packages.backend ];
        config = {
          Entrypoint = [ "backend" ];
        };
      };


      packages.frontend-image = pkgs.dockerTools.streamLayeredImage {
        name = "monorepo-with-nix-${self'.packages.frontend.pname}";
        tag = "latest";
        created = "now";
        contents =
          let
            serve = pkgs.writeShellScriptBin "serve-website" ''
              ${lib.getExe pkgs.miniserve} \
              -p 8080 \
              --index index.html \
              ${self'.packages.frontend.out} \
              "$@"
            '';
          in
          [ serve ];
        config = {
          Entrypoint = [ "serve-website" ];
        };
      };
    };
}
