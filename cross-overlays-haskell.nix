haskellProfiling:

self: super: {
  haskell = let inherit (super) haskell; in haskell // {
    packages = haskell.packages // {
      ghcWasm = haskell.packages.ghc881.override (drv: {
        ghc = (self.buildPackages.haskell.compiler.ghcHEAD.override {
          enableShared = false;
          enableRelocatedStaticLibs = false;
          enableIntegerSimple = true;
          enableTerminfo = false;
          dontStrip = true;
          dontUseLibFFIForAdjustors = true;
          disableFFI = true;
          version = "8.8.1";
          useLLVM = true;
          buildLlvmPackages = self.buildPackages.llvmPackages_8;
          llvmPackages = self.buildPackages.llvmPackages_8;
        }).overrideAttrs (drv: {
          nativeBuildInputs = drv.nativeBuildInputs or [] ++ [self.buildPackages.autoreconfHook];
          src = self.buildPackages.fetchgit {
            url = "https://github.com/WebGHC/ghc.git";
            rev = "b631c4d47c8813816e3a6531cc76ef45ab279da8";
            sha256 = "13jf1l3lcia6kgy9zbwvl2vrh7r3i97zv13a54pz5kpfr930s5dr";
            fetchSubmodules = true;
            preFetch = ''
              export HOME=$(pwd)
              git config --global url."https://github.com/WebGHC/packages-".insteadOf   https://github.com/WebGHC/packages/
            '';
          };
          # Use this to test nix-build on your local GHC checkout.
          # src = self.lib.cleanSource ./ghc;
          hardeningDisable = drv.hardeningDisable or []
            ++ ["stackprotector" "pic"];
          dontDisableStatic = true;
          NIX_NO_SELF_RPATH=1;
          patches = self.lib.filter (p: p.name != "loadpluginsinmodules.diff") drv.patches;
        });
        overrides = self.lib.composeExtensions (drv.overrides or (_:_:{})) (hsSelf: hsSuper: {
          primitive = self.haskell.lib.appendPatch hsSuper.primitive ./primitive-0.7.0.patch;
          mkDerivation = args: hsSuper.mkDerivation (args // {
            dontStrip = true;
            enableSharedExecutables = false;
            enableSharedLibraries = false;
            enableDeadCodeElimination = false;
            doHaddock = false;
            doCheck = false;
            enableLibraryProfiling = haskellProfiling;
          });
        });
      });
    };
  };
}