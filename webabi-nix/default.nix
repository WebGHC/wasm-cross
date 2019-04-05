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
    rev = "2304ac9bb930cc1052b3bd09b0dec7cd897487e8";
    sha256 = "0dgbj215ka6mnfq4i94gpvc5sfslr8iizqni5sg20vnmwnr8mvdp";
  };

in (callNode2nix "webabi" webabiSrc).package.overrideAttrs (old: {
  postInstall = ''
    ${old.postInstall or ""}
    patchShebangs .
    npm run build
  '';
})
