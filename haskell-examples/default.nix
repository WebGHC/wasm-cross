pkgs: pkgsSuper:

let
  jsaddle-src = builtins.fetchGit {
    url = https://github.com/WebGHC/jsaddle;
    rev = "d55c7f6e04de35221e913fe2841551f6ff29b229";
    ref = "ghc881-fixes";
  };
  reflex-examples-src = builtins.fetchGit {
    url = https://github.com/dfordivam/reflex-examples;
    rev = "5cb9bed97f9441bd925117b9d743574cab66f017";
    ref = "patch-1";
  };
  miso-src = pkgs.fetchgit {
    url = https://github.com/WebGHC/miso;
    rev = "6f4dac08fd57cf18d4869a8b7014e286654dd650";
    sha256 = "0gqf9hzvmk9lzmfcpf9bzb637c1767p0z9p86k2zn8a1p0gs8a9j";
    fetchSubmodules = true;
  };
  dependent-sum-src = builtins.fetchGit {
    url = https://github.com/WebGHC/dependent-sum;
    rev = "5158a7dc5e714ca82e94c76ceec838ad85b0efab";
    ref = "ghc-881-th-fixes";
  };
  haskellLib = pkgs.haskell.lib;
  inherit (pkgs) lib;
  extensions = isWasm: lib.composeExtensions
    (haskellLib.packageSourceOverrides {
      jsaddle = jsaddle-src + /jsaddle;
      jsaddle-dom = builtins.fetchGit {
        url = https://github.com/dfordivam/jsaddle-dom;
        rev = "1260311c1c600a95660cdec4cc88a097099ad876";
      };
      jsaddle-warp = jsaddle-src + /jsaddle-warp;
      jsaddle-wasm = builtins.fetchGit {
        url = https://github.com/WebGHC/jsaddle-wasm;
        rev = "4079c78aec6dc7d96ff21580971406fe914ad038";
      };

      Keyboard = reflex-examples-src + /Keyboard;
      draganddrop = reflex-examples-src + /drag-and-drop;
      fileinput = reflex-examples-src + /fileinput;
      nasapod = reflex-examples-src + /nasa-pod;
      othello = reflex-examples-src + /othello;

      miso = miso-src;

      dependent-sum = dependent-sum-src + /dependent-sum;
      dependent-sum-template = dependent-sum-src + /dependent-sum-template;
      dependent-map = builtins.fetchGit {
        url = https://github.com/WebGHC/dependent-map;
        rev = "c28ef5350b3c03c4ff92e669703e4eb67e61ffa5";
      };
      monoidal-containers = "0.6";
      lens = "4.18.1";
      witherable = "0.3.4";
      prim-uniq = builtins.fetchGit {
        url = https://github.com/WebGHC/prim-uniq;
        rev = "34570a948f7d84a1821ed6d8305ed094c4f6eb15";
      };
    })
    (self: super:
      let
        reflex-dom-pkg = import (builtins.fetchGit {
          url = https://github.com/dfordivam/reflex-dom;
          rev = "6bdc206bd83d2db62eb7d98372c9bf4fd355e7da";
          ref = "wasm-ghc-881";
        }) self;
      in {
      mkDerivation = args: super.mkDerivation (args // { doCheck = false; });
      ref-tf = haskellLib.doJailbreak super.ref-tf;

      reflex = self.callPackage (builtins.fetchGit {
        url = https://github.com/dfordivam/reflex;
        rev = "369b9db9fc50c612123b433848b8423711847462";
        ref = "ghc-881-fixes";
      }) { useTemplateHaskell = false; };
      reflex-dom-core = haskellLib.dontCheck
        (haskellLib.appendConfigureFlag
          (reflex-dom-pkg.reflex-dom-core)
          "-f-use-template-haskell")  ;
      reflex-dom = haskellLib.disableCabalFlag reflex-dom-pkg.reflex-dom "webkit2gtk";
      reflex-todomvc = self.callPackage (builtins.fetchGit {
        url = https://github.com/reflex-frp/reflex-todomvc;
        rev = "91227b8baa90a6d1e51c803eff7f966dbafe875a";
        ref = "wasm-8.6.3";
      }) {};

      miso = with haskellLib;
        let
          deps = [self.file-embed self.aeson-pretty] ++ [(if isWasm then self.jsaddle-wasm else self.jsaddle-warp)];
          patches = miso-src + /submodules.patch;
          flags = ["-fexamples"] ++ lib.optional isWasm "-fjsaddle-wasm";
        in addBuildDepends (appendPatch (appendConfigureFlags super.miso flags) patches) deps;

      constraints-extras = haskellLib.disableCabalFlag super.constraints-extras "build-readme";

      # the reflex-dom cabal2nix doesn't get deps correctly, so specify thse
      chrome-test-utils = null;
      jsaddle-webkit2gtk = null;

      # Stop building servant docs, it needs cython which fails to compile
      servant = haskellLib.overrideCabal super.servant (old: {
        postInstall = "";
        });
    });
  wasmHaskellPackages = pkgs.haskell.packages.ghcWasm.extend (extensions true);
  ghcjsHaskellPackages = pkgs.haskell.packages.ghcjs86.extend (extensions false);

  reflexExamples = {
    keyboard.pname = "Keyboard";
    draganddrop.pname = "draganddrop";
    draganddrop.assets = ["${reflex-examples-src}/drag-and-drop/arduino.jpg"];
    reflex-todomvc.pname = "reflex-todomvc";
    nasapod.pname = "nasapod";
    othello.pname = "othello";
    fileinput.pname = "fileinput";
  };
  misoExamples = {
    _2048.pname = "miso";
    _2048.ename = "2048";
    _2048.assets = [(pkgs.runCommand "2048-css" {nativeBuildInputs=[pkgs.buildPackages.sass];} "mkdir -p $out && sass ${miso-src}/examples/2048/static/main.scss $out/main.css" + /main.css)];
    _2048.styles = ["main.css"];
    flatris.pname = "miso";
    mario.pname = "miso";
    mario.assets = ["${miso-src}/examples/mario/imgs"];
    simple.pname = "miso";
    todo-mvc.pname = "miso";
  };
  examples = reflexExamples // lib.mapAttrs (n: e: e // {
    assets = e.assets or [] ++ ["${miso-src}/jsbits"];
    scripts = e.scripts or [] ++ ["jsbits/delegate.js" "jsbits/diff.js" "jsbits/isomorphic.js" "jsbits/util.js"];
  }) misoExamples;

  toWasm = name: { pname, assets ? [], ename ? name, scripts ? [], styles ? [] }:
    let pkg = wasmHaskellPackages.${pname};
    in pkgs.build-wasm-app { inherit ename pkg assets scripts styles; };

  ghcjsIndexHtml = styles: builtins.toFile "index.html" ''
    <!DOCTYPE html>
    <html>
      <head>
        ${lib.concatMapStrings (s: "<link href=\"${s}\" type=\"text/css\" rel=\"stylesheet\">") styles}
      </head>
      <body>
      </body>
      <script language="javascript" src="all.adv.min.js" defer></script>
    </html>
  '';

  toGhcjs = name: { pname, assets ? [], ename ? name, scripts ? [], styles ? [] }:
    let pkg = ghcjsHaskellPackages.${pname};
    in pkgs.runCommand "ghcjs-app-${ename}" { nativeBuildInputs = [pkgs.xorg.lndir pkgs.closurecompiler pkgs.gzip]; } ''
      mkdir -p $out
      lndir ${pkg}/bin/${ename}.jsexe $out
      ln -s ${lib.concatStringsSep " " assets} $out/
      ln -fs ${ghcjsIndexHtml styles} $out/index.html
      closure-compiler $out/all.js ${lib.optionalString (pname != "miso") "--compilation_level=ADVANCED_OPTIMIZATIONS --jscomp_off=checkVars --externs=$out/all.js.externs"} | tee $out/all.adv.min.js | gzip > $out/all.adv.min.js.gz
    '';

in {
  examples.wasm = pkgs.recurseIntoAttrs (lib.mapAttrs toWasm examples);
  examples.ghcjs = pkgs.recurseIntoAttrs (lib.mapAttrs toGhcjs examples);
}
