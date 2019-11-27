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
          useLLVM = true;
          buildLlvmPackages = self.buildPackages.llvmPackages_HEAD;
          llvmPackages = self.buildPackages.llvmPackages_HEAD;
        }).overrideAttrs (drv: {
          nativeBuildInputs = drv.nativeBuildInputs or [] ++ [self.buildPackages.autoreconfHook];
          src = self.buildPackages.fetchgit {
            url = "https://github.com/WebGHC/ghc.git";
            rev = "a0755fefa31adc4b451884540d08f3d5c5ea918c";
            sha256 = "1j0rq5b06yx9cfadjfrhq4lai7kls916iy7hcb52iq4dr8hq9n2i";
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

