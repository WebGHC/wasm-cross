wasm-cross
---

This repo contains the nix expressions necessary to build cross a
compiling toolchain for WebAssembly. A secondary goal of this repo is
to make it easy or trivial to build cross compiling toolchains for
arbitrary LLVM targets. Currently, `wasm-cross` can be used to build
"Hello, World!" C programs for `aarch64-unknown-linux-gnu`, Raspberry
Pi, and `wasm32-unknown-uknown-wasm`. It can also build the `hello`
Hackage package for aarch64 using GHC as a cross compiler.

### Design

1. `./llvm-head` contains the nix expressions for building LLVM,
   Clang, and various LLVM libraries from near-head checkouts. The
   libraries are automatically built to target whatever system Nixpkgs
   is targetting in the `host == target` stage. But Clang is not built
   with the cross system set as its default target in the `host ==
   build` stage because it's better to have a single build of Clang
   that `stdenv` massages into targetting the appropriate
   platform. This avoids needlessly rebuilding Clang many times when
   it's perfectly capable of targetting many platforms with the same
   binary.
2. `./musl-cross.nix` builds libc for the target. When the target is
   wasm, it builds
   [wasm-syslib-builder](https://github.com/WebGHC/wasm-syslib-builder),
   which is little more than a Makefile for Emscripten's libc
   implementation, which is based on musl. For other targets, an
   ordinary musl build is used.
3. `./cross.nix` defines the cross compiling stages. The first stages
   are the vanilla boot stages, which produce a normal Nixpkgs. The
   next stage builds a `cc-wrapper` around Clang that targets the
   cross system using `compiler-rt` as the runtime, and
   `musl-cross.nix` as the `libc`. The final stage uses a `stdenv`
   that will target the cross system by default.
4. `./fib-example` is a simple C program that returns a fibonacci
   calculation. The goal of this program is to demonstrate that a
   CMake project can be built for WebAssembly with relative ease. A
   secondary goal is to show that this requires minimal porting work,
   such that a project designed for arbitrary cross compilation to
   platforms such as Arm can be built for WebAssembly without changing
   the build system.
5. GHC, for the most part, is handled in `nixpkgs`. John Ericson
   (@Ericson2314) has already done much work on getting the GHC Nix
   expressions to properly build cross compilers. For aarch64, little
   work was needed to build a functioning `haskellPackages`. However,
   GHC is currently built from
   [a fork](https://github.com/WebGHC/ghc/tree/WebGHC) in an effort to
   support WebAssembly as a target.

### Notes

1. Upstream `lld` does not yet support the `wasm` object file
   format. So [a fork](https://github.com/WebAssembly/lld/tree/wasm)
   is used that does support it.
2. We have
   [forked `nixpkgs`](https://github.com/WebGHC/nixpkgs/tree/wasm-cross)
   in order to support a variety of custom needs. When John Ericson
   has finished upstreaming a large amount of cross compilation
   infrastructure into nixpkgs, these changes can begin to be
   generalized and upstreamed.
