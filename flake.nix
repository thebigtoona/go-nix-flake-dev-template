/*
Go dev on nix template flake.
- use nix build to build the app
- use nix develop to create a dev environment with basic go tooling
*/
{
  description = "go development with nixos flake template";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    # systems to support. add more as needed here
    supportedSystems = ["x86_64-linux"];

    # helper function to generate an attrset for supportedSystems
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    # nixpkgs instance for supported system types
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in {
      package_name = pkgs.buildGoModule {
        pname = "package_name";
        version = "0.0.1";
        src = ./.;

        # hash to lock the dependencies of the pakcage see
        # https://www.tweag.io/blog/2021-03-04-gomod2nix/ for details
        # vendorHash = pkgs.lib.fakeHash; # use to actually get the hash
        vendorHash = null; # this is null at the moment because we have no vendor deps
      };
    });

    # add dependencies that are only needed for development
    devShells = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [go gopls gotools go-tools];
      };
    });

    # the default package for 'nix build'. This makes sense if the flake provides only one
    # package or if there is a clean main package.
    # defaultPackage = forAllSystems (system: self.packages.${system}.package_name);
  };
}
