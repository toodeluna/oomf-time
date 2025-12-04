{
  description = "Application to check current time of the oomfs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in
    {
      formatter.aarch64-darwin = pkgs.treefmt.withConfig {
        runtimeInputs = [
          pkgs.nixfmt
          pkgs.swift-format
        ];

        settings = {
          tree-root-file = "flake.nix";

          formatter.nixfmt = {
            command = "nixfmt";
            includes = [ "*.nix" ];
          };

          formatter.swift-format = {
            command = "swift-format";
            includes = [ "*.swift" ];

            options = [
              "format"
              "-i"
            ];
          };
        };
      };

      devShells.aarch64-darwin.default = pkgs.mkShell {
        inputsFrom = [ self.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      };

      packages.aarch64-darwin.default = pkgs.stdenv.mkDerivation {
        pname = "oomf-time";
        version = "0.1.0";
        src = ./.;
        nativeBuildInputs = [ pkgs.swift ];

        buildInputs = [
          pkgs.swiftPackages.Foundation
          pkgs.swiftPackages.swiftpm
        ];

        buildPhase = ''
          runHook preBuild
          swift build -c release
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p "$out/bin"
          cp ".build/release/oomf-time" "$out/bin"
          runHook postInstall
        '';
      };
    };
}
