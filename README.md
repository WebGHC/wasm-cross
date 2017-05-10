wasm-cross
---

This repo is a bit of a mish mash of tools necessary for cross
compiling to WebAssembly. WIP, of course. The subdirectories are as
follows:

llvm-head
---

This has nix expressions for building LLVM from a near-head checkout
of git. It also enables the experimental WebAssembly backend during
building. It's currently copied from the nix expressions for `llvm-4`
in `nixpkgs`, except for the changes in sources, and some changes to
the way `compiler-rt` is handled.

wasm-cross
---

Import this instead of `nixpkgs` to get a `nixpkgs` that cross
compiles to WebAssembly. This is currently not working.

cmake-hello-world
---

This is a nix expression for cloning and building a simple "Hello,
World" with cmake, via
https://github.com/jameskbride/cmake-hello-world. This is used a
simple test for whether wasm-cross is working.

nixpkgs
---

Just a nix expression for checking out the correct version of nixpkgs
from https://github.com/WebGHC/nixpkgs. Use `import ./nixpkgs` in
place of `import <nixpkgs>`.

---

Changes to the LLVM and `nixpkgs` expressions are expected to be
upstreamed eventually.
