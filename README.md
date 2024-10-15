# Go on nix development template

this is a template for developing go apps while using nix or being on nixos

## Getting Started

1. in `flake.nix`

   - replace `package_name` with your own app name
   - replace the description field with your own app description.

<br />
   
2. run `nix develop` to get dropped into the go env

3. run go mod init <your_package_name>. from the dev enviroment to make the
   go.mod file. `nix build` and `nix run` won't work without it while using
   pkgs.buildGoModule

## Usage

- `nix build` - build the package
- `nix run` - build and run the package
- `nix develop` - enter go dev env
