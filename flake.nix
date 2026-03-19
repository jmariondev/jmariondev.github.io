{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { pkgs, system, ... }:
        let
          pkgs-master = import inputs.nixpkgs-master {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              (final: prev: { claude-code-bin = pkgs-master.claude-code-bin; })
            ];
          };

          devShells.default = pkgs.mkShellNoCC {
            buildInputs = with pkgs; [
              # Dev tools
              claude-code-bin
              git
              just
              ripgrep
              zola

              # Nix tooling
              nil # Nix LSP
              nixpkgs-fmt
              nvd
            ];
          };
        };
    };
}
