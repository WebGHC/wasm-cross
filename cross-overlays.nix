haskellProfiling: { lib, crossSystem, ... }:

self: super: {
  libiconvReal =
    if crossSystem.isWasm
    then super.libiconvReal.overrideDerivation (attrs: {patches = [./libiconv-wasm32.patch];})
    else super.libiconvReal;
  libiconv = self.libiconvReal; # By default, this wants to pull stuff out of glibc or something

  haskell = let inherit (super) haskell; in haskell // {
    packages = haskell.packages // {
      ghcWasm = haskell.packages.ghc881.override (drv: {
        ghc = (self.buildPackages.haskell.compiler.ghcHEAD.override {
          enableShared = false;
          enableRelocatedStaticLibs = false;
          enableIntegerSimple = true;
          enableTerminfo = !crossSystem.isWasm;
          dontStrip = true;
          dontUseLibFFIForAdjustors = crossSystem.isWasm;
          disableFFI = crossSystem.isWasm;
          version = "8.8.1";
          ghcFlavour = "quick-cross";
          useLLVM = true;
          buildLlvmPackages = self.buildPackages.llvmPackages_HEAD;
          llvmPackages = self.buildPackages.llvmPackages_HEAD;
        }).overrideAttrs (drv: {
          nativeBuildInputs = drv.nativeBuildInputs or [] ++ [self.buildPackages.autoreconfHook];
          src = self.buildPackages.fetchgit {
            url = "https://github.com/WebGHC/ghc.git";
            rev = "5f8785d2fa4db2706ef388f5b7ca796341f5267d";
            sha256 = "0v8qgc90zlv604pf29b03z7lw1sbqpykw05szqlcs4qqn66psb1v";
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
          patches = lib.filter (p: p.name != "loadpluginsinmodules.diff") drv.patches;
        });
        overrides = self.lib.composeExtensions (drv.overrides or (_:_:{})) (hsSelf: hsSuper: {
          primitive = self.haskell.lib.appendPatch hsSuper.primitive ./primitive.patch;
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

