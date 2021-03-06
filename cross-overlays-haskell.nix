ghcSrc: ghcVersion: haskellProfiling:
self: super: {
  haskell =
  let inherit (super) haskell;
      ghcPkgName = "ghc" + super.lib.strings.stringAsChars (x: if x == "." then "" else x) ghcVersion;
  in haskell // {
    packages = haskell.packages // {
      ghcWasm = haskell.packages.${ghcPkgName}.override (drv: {
        ghc = (self.buildPackages.haskell.compiler.ghcHEAD.override {
          enableShared = false;
          enableRelocatedStaticLibs = false;
          enableIntegerSimple = true;
          enableTerminfo = false;
          # Options for newer nixpkgs
          # enableDwarf = false;
          # libffi = null;
          version = ghcVersion;
          useLLVM = true;
          buildLlvmPackages = self.buildPackages.llvmPackages_8;
          llvmPackages = self.buildPackages.llvmPackages_8;
        }).overrideAttrs (drv: {
          nativeBuildInputs = drv.nativeBuildInputs or [] ++ [self.buildPackages.autoreconfHook self.buildPackages.buildPackages.git];
          src = ghcSrc;
          # Use this to test nix-build on your local GHC checkout.
          # src = self.lib.cleanSource ./ghc;
          hardeningDisable = drv.hardeningDisable or []
            ++ ["stackprotector" "pic"];
          dontDisableStatic = true;
          NIX_NO_SELF_RPATH=1;
          patches = self.lib.filter (p: p.name != "loadpluginsinmodules.diff") (drv.patches or []);
        });
        overrides = self.lib.composeExtensions (drv.overrides or (_:_:{})) (hsSelf: hsSuper: {
          primitive = self.haskell.lib.appendPatch hsSuper.primitive (if ghcVersion == "8.6.5" then ./primitive-0.6.4.patch else ./primitive-0.7.0.patch);
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