{
  description = "cse144 deep learning";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;

          config.rocmSupport = true;
        };

        python = pkgs.python3.withPackages (
          ps: with ps; [
            jupyter
            notebook
            ipykernel

            numpy
            pandas
            matplotlib
            scikit-learn
            scipy

            torch
            torchvision
            kagglehub
            timm
            transformers

          ]
        );
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            python
            pkgs.basedpyright
            pkgs.nbstripout
          ];
        };
      }
    );
}
