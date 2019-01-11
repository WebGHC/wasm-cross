haskellProfiling: { lib, crossSystem, ... }:

self: super: {
  libiconvReal =
    if crossSystem.isWasm
    then super.libiconvReal.overrideDerivation (attrs: {patches = [./libiconv-wasm32.patch];})
    else super.libiconvReal;
  libiconv = self.libiconvReal; # By default, this wants to pull stuff out of glibc or something

  haskell = let inherit (super) haskell; in haskell // {
    packages = haskell.packages // {
      ghcWasm = haskell.packages.ghc863.override (drv: {
        ghc = (self.buildPackages.haskell.compiler.ghcHEAD.override {
          enableShared = false;
          enableRelocatedStaticLibs = false;
          enableIntegerSimple = true;
          enableTerminfo = !crossSystem.isWasm;
          dontStrip = true;
          dontUseLibFFIForAdjustors = crossSystem.isWasm;
          disableFFI = crossSystem.isWasm;
          version = "8.6.3";
          useLLVM = true;
          buildLlvmPackages = self.buildPackages.llvmPackages_HEAD;
          llvmPackages = self.buildPackages.llvmPackages_HEAD;
        }).overrideAttrs (drv: {
          nativeBuildInputs = drv.nativeBuildInputs or [] ++ [self.buildPackages.autoreconfHook];
          src = self.buildPackages.fetchgit {
            url = "https://github.com/WebGHC/ghc.git";
            rev = "9af15622eead357865f33eb1945bd2fe3da70c90";
            sha256 = "08xzlasdv14hhfdszk7khjlhjifpzdlc1fybaiwgik3nrhphlkjf";
            fetchSubmodules = true;
            preFetch = ''
              export HOME=$(pwd)
              git config --global url."https://github.com/WebGHC/packages-".insteadOf   https://github.com/WebGHC/packages/
            '';
          };
          # Use this to test nix-build on your local GHC checkout.
          # src = lib.cleanSource ./ghc;
          hardeningDisable = drv.hardeningDisable or []
            ++ ["stackprotector"]
            ++ lib.optional crossSystem.isWasm "pic";
          dontDisableStatic = true;
          NIX_NO_SELF_RPATH=1;
        });
        overrides = self.lib.composeExtensions (drv.overrides or (_:_:{})) (hsSelf: hsSuper: let haskellLib = self.haskell.lib; in {
          primitive = haskellLib.appendPatch hsSuper.primitive ./primitive.patch;

          ref-tf = haskellLib.doJailbreak hsSuper.ref-tf;
          jsaddle = hsSelf.callCabal2nix "jsaddle" (builtins.fetchGit https://github.com/ghcjs/jsaddle + /jsaddle) {};
          jsaddle-wasm = hsSelf.callCabal2nix "jsaddle-wasm" (builtins.fetchGit https://github.com/WebGHC/jsaddle-wasm) {};
          jsaddle-dom = hsSelf.callCabal2nix "jsaddle-dom" (builtins.fetchGit https://github.com/ghcjs/jsaddle-dom) {};

          reflex = hsSelf.callPackage (builtins.fetchGit https://github.com/reflex-frp/reflex) { useTemplateHaskell = false; };
          reflex-dom-core =
            haskellLib.appendConfigureFlag
              (hsSelf.callPackage (builtins.fetchGit { url = https://github.com/reflex-frp/reflex-dom; ref = "wasm-8.6.3"; } + /reflex-dom-core) {})
              "-f-use-template-haskell";
          reflex-todomvc =
            haskellLib.appendConfigureFlag
              (hsSelf.callPackage (builtins.fetchGit { url = https://github.com/reflex-frp/reflex-todomvc; ref = "wasm-8.6.3"; }) {})
              "-fwasm";

          mkDerivation = args: hsSuper.mkDerivation (args // {
            dontStrip = true;
            enableSharedExecutables = false;
            enableSharedLibraries = false;
            enableDeadCodeElimination = false;
            doHaddock = !crossSystem.isWasm;
            doCheck = !crossSystem.isWasm;
            enableLibraryProfiling = haskellProfiling;
          });
        });
      });
    };
  };
}

