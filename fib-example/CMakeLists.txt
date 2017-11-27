project (FIB_EXAMPLE)
add_executable (fib fib.c)
install (TARGETS fib DESTINATION bin)
install (FILES index.html wasm.js DESTINATION bin)
