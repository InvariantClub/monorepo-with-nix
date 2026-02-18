{ inputs, ... }: {
  perSystem =
    { pkgs
    , lib
    , packages
    , self'
    , ...
    }:
    let
      backend = {
        command = ''
          ${self'.packages.backend}/bin/backend
        '';
      };

      frontend = {
        command = ''
          ${lib.getExe pkgs.miniserve} \
            -p 3001 \
            --index index.html \
            ${self'.packages.frontend.out}
        '';
      };
    in
    {
      process-compose.serve = {
        package = pkgs.process-compose;
        settings = {
          processes = {
            inherit
              backend
              frontend
              ;
          };
        };
      };
    };
}
