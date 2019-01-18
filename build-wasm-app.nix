{ lib, buildPackages, runCommand }:

let
  indexHtml = { ename, scripts, styles }: builtins.toFile "index.html" ''
    <!doctype html>
    <html>
      <head>
        <meta charset="utf-8"></meta>
        ${lib.concatMapStrings (s: "<link href=\"${s}\" type=\"text/css\" rel=\"stylesheet\">") styles}
      </head>

      <body>
        <script src="jsaddle.js"></script>
        ${lib.concatMapStrings (s: "<script src=\"${s}\"></script>") scripts}
        <script>
          var jsaddleVals = jsaddleJsInit();
          const worker = new Worker("worker_runner.js");
          worker.postMessage({ url: "${ename}-opt"
                             , jsaddleVals: jsaddleVals }
                             , [jsaddleVals.jsaddleListener]);
        </script>
      </body>
    </html>
  '';

in { ename, pkg, assets ? [], scripts ? [], styles ? [] }: runCommand "wasm-app-${ename}" {
  nativeBuildInputs = [ buildPackages.xorg.lndir buildPackages.binaryen ];
  passthru = { inherit pkg; };
} ''
  mkdir -p $out
  lndir ${buildPackages.buildPackages.webabi}/lib/node_modules/webabi/build $out
  lndir ${buildPackages.buildPackages.webabi}/lib/node_modules/webabi/jsaddleJS $out
  ln -s ${pkg}/bin/${ename} $out/
  ${lib.concatMapStringsSep "\n" (a: "ln -s ${a} $out/") assets}
  ln -s ${indexHtml { inherit ename scripts styles; }} $out/index.html
  wasm-opt -Oz $out/${ename} -o $out/${ename}-opt
''
