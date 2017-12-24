{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."async"."^2.1.4" =
    self.by-version."async"."2.6.0";
  by-version."async"."2.6.0" = self.buildNodePackage {
    name = "async-2.6.0";
    version = "2.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/async/-/async-2.6.0.tgz";
      name = "async-2.6.0.tgz";
      sha1 = "61a29abb6fcc026fea77e56d1c6ec53a795951f4";
    };
    deps = {
      "lodash-4.17.4" = self.by-version."lodash"."4.17.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."browserfs"."^1.4.3" =
    self.by-version."browserfs"."1.4.3";
  by-version."browserfs"."1.4.3" = self.buildNodePackage {
    name = "browserfs-1.4.3";
    version = "1.4.3";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/browserfs/-/browserfs-1.4.3.tgz";
      name = "browserfs-1.4.3.tgz";
      sha1 = "92ffc6063967612daccdb8566d3fc03f521205fb";
    };
    deps = {
      "async-2.6.0" = self.by-version."async"."2.6.0";
      "pako-1.0.6" = self.by-version."pako"."1.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "browserfs" = self.by-version."browserfs"."1.4.3";
  by-spec."lodash"."^4.14.0" =
    self.by-version."lodash"."4.17.4";
  by-version."lodash"."4.17.4" = self.buildNodePackage {
    name = "lodash-4.17.4";
    version = "4.17.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash/-/lodash-4.17.4.tgz";
      name = "lodash-4.17.4.tgz";
      sha1 = "78203a4d1c328ae1d86dca6460e369b57f4055ae";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pako"."^1.0.4" =
    self.by-version."pako"."1.0.6";
  by-version."pako"."1.0.6" = self.buildNodePackage {
    name = "pako-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pako/-/pako-1.0.6.tgz";
      name = "pako-1.0.6.tgz";
      sha1 = "0101211baa70c4bca4a0f63f2206e97b7dfaf258";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
}
