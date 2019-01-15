pkgs: pkgsSuper:

let
  reflex-dom-src = builtins.fetchGit {
    url = https://github.com/reflex-frp/reflex-dom;
    rev = "fe47268aa76ce0667fee024e501fea58f715f5c9";
    ref = "wasm-8.6.3";
  };
  jsaddle-src = builtins.fetchGit {
    url = https://github.com/ghcjs/jsaddle;
    rev = "a9acbcf966ea9fa14d36813da3e94d75bd9acf76";
  };
  reflex-examples-src = builtins.fetchGit {
    url = https://github.com/reflex-frp/reflex-examples;
    rev = "debb45a94556bcb244ab8b61233c9b1a827ab0b9";
    ref = "webghc";
  };
  miso-src = pkgs.fetchgit {
    url = https://github.com/WebGHC/miso;
    rev = "6f4dac08fd57cf18d4869a8b7014e286654dd650";
    sha256 = "0gqf9hzvmk9lzmfcpf9bzb637c1767p0z9p86k2zn8a1p0gs8a9j";
    fetchSubmodules = true;
  };
  haskellLib = pkgs.haskell.lib;
  inherit (pkgs) lib;
  extensions = isWasm: lib.composeExtensions
    (haskellLib.packageSourceOverrides {
      jsaddle = jsaddle-src + /jsaddle;
      jsaddle-dom = builtins.fetchGit {
        url = https://github.com/ghcjs/jsaddle-dom;
        rev = "6ba167147476adebe7783e1521591aa3fd13da28";
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
      servant = "0.15";
    })
    (self: super: {
      mkDerivation = args: super.mkDerivation (args // { doCheck = false; });
      ref-tf = haskellLib.doJailbreak super.ref-tf;

      reflex = self.callPackage (builtins.fetchGit {
        url = https://github.com/reflex-frp/reflex;
        rev = "185e4eaca5e32dfeb879b4bc6c5429c2f34739c0";
      }) { useTemplateHaskell = false; };
      reflex-dom-core =
        haskellLib.appendConfigureFlag
          (self.callPackage (reflex-dom-src + /reflex-dom-core) {})
          "-f-use-template-haskell";
      reflex-dom = self.callPackage (reflex-dom-src + /reflex-dom) {};
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
    });
  wasmHaskellPackages = pkgs.haskell.packages.ghcWasm.extend (extensions true);
  ghcjsHaskellPackages = pkgs.haskell.packages.ghcjs86.extend (extensions false);

  examples = {
    keyboard.pname = "Keyboard";
    draganddrop.pname = "draganddrop";
    draganddrop.assets = ["arduino.jpg"];
    reflex-todomvc.pname = "reflex-todomvc";
    nasapod.pname = "nasapod";
    othello.pname = "othello";
    fileinput.pname = "fileinput";

    _2048.pname = "miso";
    _2048.ename = "2048";
    flatris.pname = "miso";
    mario.pname = "miso";
    mario.assets = ["imgs"];
    simple.pname = "miso";
    todo-mvc.pname = "miso";
  };

  toWasm = name: { pname, assets ? [], ename ? name }:
    let pkg = wasmHaskellPackages.${pname};
    in (pkgs.build-wasm-app ename pkg).overrideAttrs (old: {
      buildCommand = ''
        ${old.buildCommand}
        ln -s ${lib.concatMapStringsSep " " (f: "${pkg.src}/${f}") assets} $out/
      '';
    });

  toGhcjs = name: { pname, assets ? [], ename ? name }:
    let pkg = ghcjsHaskellPackages.${pname};
    in pkgs.runCommand "ghcjs-app-${ename}" { nativeBuildInputs = [pkgs.xorg.lndir]; } ''
      mkdir -p $out
      lndir ${pkg}/bin/${ename}.jsexe $out
      ln -s ${lib.concatMapStringsSep " " (f: "${pkg.src}/${f}") assets} $out/
    '';

in {
  examples.wasm = pkgs.recurseIntoAttrs (lib.mapAttrs toWasm examples);
  examples.ghcjs = pkgs.recurseIntoAttrs (lib.mapAttrs toGhcjs examples);
}
