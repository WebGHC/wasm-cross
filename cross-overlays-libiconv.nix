(self: super: {
  libiconvReal = super.libiconvReal.overrideDerivation (attrs: {patches = [./libiconv-wasm32.patch];});
  libiconv = self.libiconvReal; # By default, this wants to pull stuff out of glibc or something
})