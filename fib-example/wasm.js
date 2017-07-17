function fetchAndInstantiate(url, importObject) {
  return fetch(url).then(response =>
    response.arrayBuffer()
  ).then(bytes =>
    WebAssembly.instantiate(bytes, importObject)
  ).then(results =>
    results.instance
  );
}



var importObject = {
    "env": {
        "__eqtf2": () => {throw "NYI"},
        "__extenddftf2": () => {throw "NYI"},
        "__fixtfsi": () => {throw "NYI"},
        "__fixunstfsi": () => {throw "NYI"},
        "__floatsitf": () => {throw "NYI"},
        "__floatunsitf": () => {throw "NYI"},
        "getenv": () => {throw "NYI"},
        "__lock": () => {throw "NYI"},
        "__map_file": () => {throw "NYI"},
        "__netf2": () => {throw "NYI"},
        "sbrk": () => {throw "NYI"},
        "__stack_chk_fail": () => {throw "NYI"},
        "__stack_chk_guard": () => {throw "NYI"},
        "__syscall140": () => {throw "NYI"},
        "__syscall146": () => {throw "NYI"},
        "__syscall6": () => {throw "NYI"},
        "__syscall91": () => {throw "NYI"},
        "__unlock": () => {throw "NYI"},
        "__unordtf2": () => {throw "NYI"},
    }
};

fetchAndInstantiate("fib", importObject).then(function(instance) {
    console.log(instance.exports.main);
    console.log(instance.exports.main());
});
