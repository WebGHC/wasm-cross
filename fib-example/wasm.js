var importObject = {
    "env": {
	// JS functions required by the wasm module go here
    }
};

function fetchAndInstantiate(url, importObject) {
  return fetch(url).then(response =>
    response.arrayBuffer()
  ).then(bytes =>
    WebAssembly.instantiate(bytes, importObject)
  ).then(results =>
    results.instance
  );
}

fetchAndInstantiate("fib", importObject).then(function(instance) {
    console.log(instance.exports.main);
    console.log(instance.exports.main());
    console.log(instance.exports.fib(7));
});