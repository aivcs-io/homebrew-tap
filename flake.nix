{
  description = "AIVCS Homebrew tap — propel checks and release gates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python3;
      in {
        packages = {
          tap-release-gate = pkgs.writeShellApplication {
            name = "tap-release-gate";
            runtimeInputs = with pkgs; [ python syft grype ];
            text = ''
              exec ${python}/bin/python3 ${./tools/tap_release_gate.py} "$@"
            '';
          };
          bump-formula = pkgs.writeShellApplication {
            name = "bump-formula";
            runtimeInputs = [ python ];
            text = ''
              exec ${python}/bin/python3 ${./tools/bump_formula.py} "$@"
            '';
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs;
            [ gitleaks syft grype python3 curl ]
            ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.brew ];
        };
      });
}
