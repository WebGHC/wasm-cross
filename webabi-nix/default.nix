{ webabi ? { outPath = ./.; name = "webabi"; }
, pkgs ? import <nixpkgs> {}
}:
let
  nodePackages = import "${pkgs.path}/pkgs/top-level/node-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv nodejs fetchurl fetchgit;
    neededNatives = [ pkgs.python ] ++ pkgs.lib.optional pkgs.stdenv.isLinux pkgs.utillinux;
    self = nodePackages;
    generated = ./test.nix;
  };
in rec {
  tarball = pkgs.runCommand "webabi-0.0.1.tgz" { buildInputs = [ pkgs.nodejs ]; } ''
    mv `HOME=$PWD npm pack ${webabi}` $out
  '';
  build = nodePackages.buildNodePackage {
    name = "webabi-0.0.1";
    src = [ tarball ];
    buildInputs = nodePackages.nativeDeps."webabi" or [];
    deps = [ nodePackages.by-spec."browserfs"."^1.4.3" ];
    peerDependencies = [];
  };
}
