{ nodePackages, git, pkgs, system }:

let
  runNode2nix = name: src: pkgs.runCommand "${name}-nix" { nativeBuildInputs = [nodePackages.node2nix]; } ''
    mkdir -p $out
    cd $out
    node2nix -i ${src}/package.json -l ${src}/package-lock.json --include-peer-dependencies --nodejs-10 -d -o ./node-packages.nix -e ./node-env.nix -c ./default.nix
  '';

  callNode2nix = name: src: import (runNode2nix name src) { inherit pkgs system; };

  webabiSrc = pkgs.fetchFromGitHub {
    owner = "WebGHC";
    repo = "webabi";
    rev = "d62c831d91f964f1894a7ec72ad9b73318378982";
    sha256 = "1c8hlawi300ip32wpaxbcf8njxs0y9af7qrqa2d7addkybhcgcjc";
  };

in (callNode2nix "webabi" webabiSrc).package.overrideAttrs (old: {
  postInstall = ''
    ${old.postInstall or ""}
    patchShebangs .
    npm run build
  '';
})
