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
    rev = "944a6234495c1767cca50217dd840329a051f955";
    sha256 = "0l4psw0nqiw328xjsl1w16f0jc7n0ndk9bzmsl96jv74iw1cn6vn";
  };

in (callNode2nix "webabi" webabiSrc).package.overrideAttrs (old: {
  postInstall = ''
    ${old.postInstall or ""}
    patchShebangs .
    npm run build
  '';
})
