self: super: {

  webabi = self.callPackage ./webabi {};

  webghc-runner = self.writeShellScriptBin "webghc-runner" ''
    exec ${self.nodejs-8_x}/bin/node ${self.webabi}/lib/node_modules/webabi/build/node_runner.js "$@"
  '';

  build-wasm-app = self.callPackage ./build-wasm-app.nix {};
}
