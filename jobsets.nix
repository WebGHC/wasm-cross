{ wasm-cross-prs }:

let
  pkgs = import ./nixpkgs {};
  mkFetchGithub = value: {
    inherit value;
    type = "git";
    emailresponsible = false;
  };
in
with pkgs.lib;
let
  defaults = jobs: {
    inherit (jobs) description;
    enabled = 1;
    hidden = false;
    keepnr = 10;
    schedulingshares = 100;
    checkinterval = 120;
    enableemail = false;
    emailoverride = "";
    nixexprinput = "wasm-cross";
    nixexprpath = "release.nix";
    inputs = jobs.inputs // {
      nixpkgs = {
        type = "git";
        value = "https://github.com/NixOS/nixpkgs-channels.git nixos-unstable";
        emailresponsible = false;
      };
    };
  };
  branchJobset = branch: defaults {
    description = "wasm-cross-${branch}";
    inputs = {
      wasm-cross = {
        value = "https://github.com/WebGHC/wasm-cross.git ${branch}";
        type = "git";
        emailresponsible = false;
      };
    };
  };
  makePr = num: info: {
    name = "wasm-cross-pr-${num}";
    value = defaults {
      description = "#${num}: ${info.title}";
      inputs = {
        wasm-cross = {
          value = "https://github.com/${info.head.repo.owner.login}/${info.head.repo.name}.git ${info.head.ref}";
          type = "git";
          emailresponsible = false;
        };
      };
    };
  };
  prs = mapAttrs' makePr (builtins.fromJSON (builtins.readFile wasm-cross-prs));
  jobsetsAttrs = prs // genAttrs ["master"] branchJobset;
in {
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
}
