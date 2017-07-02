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
        "__syscall_cp": () => {throw "NYI"},
        "__lockfile": () => {throw "NYI"},
        "__unlockfile": () => {throw "NYI"},
        "pthread_self": () => {throw "NYI"},
        "__syscall1": () => {throw "NYI"},
        "__mmap": () => {throw "NYI"},
        "__syscall0": () => {throw "NYI"},
        "__syscall3": () => {throw "NYI"},
        "abort": () => {throw "NYI"},
        "__mremap": () => {throw "NYI"},
        "__munmap": () => {throw "NYI"},
        "__madvise": () => {throw "NYI"},
        "__lock": () => {throw "NYI"},
        "__unlock": () => {throw "NYI"},
        "_Exit": () => {throw "NYI"},
        "__syscall5": () => {throw "NYI"},
        "__stdio_write": () => {throw "NYI"}
    }
};

fetchAndInstantiate("fib", importObject).then(function(instance) {
    console.log(instance.exports.main);
    console.log(instance.exports.main());
});
