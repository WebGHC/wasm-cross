{ lib, crossSystem, ... }:

self: super: {
  libiconvReal =
    if crossSystem.isWasm
    then super.libiconvReal.overrideDerivation (attrs: {patches = [./libiconv-wasm32.patch];})
    else super.libiconvReal;
  libiconv = self.libiconvReal; # By default, this wants to pull stuff out of glibc or something

  haskell = let inherit (super) haskell; in haskell // {
    packages = haskell.packages // {
      ghc863 = haskell.packages.ghc863.override (drv: {
        ghc = (drv.ghc.override {
          enableShared = false;
          enableRelocatedStaticLibs = false;
          enableIntegerSimple = true;
          enableTerminfo = !crossSystem.isWasm;
          dontStrip = true;
          dontUseLibFFIForAdjustors = crossSystem.isWasm;
          disableFFI = crossSystem.isWasm;
          useLLVM = true;
          buildLlvmPackages = self.buildPackages.llvmPackages_HEAD;
          llvmPackages = self.buildPackages.llvmPackages_HEAD;
        }).overrideAttrs (drv: {
          src =
            if !(crossSystem.isWasm)
              then drv.src
              else self.buildPackages.fetchgit {
                url = "https://github.com/WebGHC/ghc.git";
                rev = "35a703dad585639021eb88acdaf117837078eb47";
                sha256 = "1afx9y4648351g123kp8hkx74q0wbixh06x41gg6nrkmszdw8g6b";
                preFetch = ''
                  export HOME=$(pwd)
                  git config --global url."git://github.com/WebGHC/packages-".insteadOf     git://github.com/WebGHC/packages/
                  git config --global url."http://github.com/WebGHC/packages-".insteadOf    http://github.com/WebGHC/packages/
                  git config --global url."https://github.com/WebGHC/packages-".insteadOf   https://github.com/WebGHC/packages/
                  git config --global url."ssh://git@github.com/WebGHC/packages-".insteadOf ssh://git@github.com/WebGHC/packages/
                  git config --global url."git@github.com:WebGHC/packages-".insteadOf       git@github.com:WebGHC/packages/
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
        overrides = self.lib.composeExtensions (drv.overrides or (_:_:{})) (hsSelf: hsSuper: {
          primitive = self.haskell.lib.appendPatch hsSuper.primitive ./primitive.patch;
          mkDerivation = args: hsSuper.mkDerivation (args // {
            dontStrip = true;
            enableSharedExecutables = false;
            enableSharedLibraries = false;
            enableDeadCodeElimination = false;
            doHaddock = !crossSystem.isWasm;
          });
        });
      });
    };
  };
}

