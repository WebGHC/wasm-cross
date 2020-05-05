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
        ${lib.concatMapStrings (s: "<script src=\"${s}\"></script>") scripts}
        <script type="text/javascript">var wasmFile = '${ename}-opt';</script>
        <script defer="defer" src="jsaddle_core.js" type="text/javascript"></script>
        <script defer="defer" src="jsaddle_mainthread_interface.js" type="text/javascript"></script>
        <script defer="defer" src="mainthread_runner.js" type="text/javascript"></script>
      </body>
    </html>
  '';

  indexHtmlWorker = { ename, scripts, styles }: builtins.toFile "index.html" ''
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

# On certain apps like reflex-todomvc, doing wasm-strip first and then wasm-opt gives
# smaller size files.
in { ename, pkg, assets ? [], scripts ? [], styles ? [] }: runCommand "wasm-app-${ename}" {
  nativeBuildInputs = [ buildPackages.xorg.lndir buildPackages.binaryen buildPackages.wabt];
  passthru = { inherit pkg; };
  meta.platforms = ["wasm32-unknown"];
} ''
  mkdir -p $out
  lndir ${buildPackages.buildPackages.webabi}/lib/node_modules/webabi/build $out
  lndir ${buildPackages.buildPackages.webabi}/lib/node_modules/webabi/jsaddleJS $out
  ln -s ${pkg}/bin/${ename} $out/
  ${lib.concatMapStringsSep "\n" (a: "ln -s ${a} $out/") assets}
  ln -s ${indexHtml { inherit ename scripts styles; }} $out/index.html
  cp ${pkg}/bin/${ename} $out/${ename}-tmp
  chmod u+w $out/${ename}-tmp
  wasm-strip $out/${ename}-tmp
  wasm-opt -Oz $out/${ename}-tmp -o $out/${ename}-opt
  rm $out/${ename}-tmp
  gzip -c $out/${ename}-opt > $out/${ename}-opt.gz
''
