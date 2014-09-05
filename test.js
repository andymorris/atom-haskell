var ref = require("ref");
var ffi = require("ffi");

var stringPtr = ref.refType(ref.types.CString);
var lib = ffi.Library("dist/build/libHShaskell-ffi-0.1.0.0-ghc7.8.3", {
  hs_init: ["void", ["int", "string"]],
  hs_exit: ["void", []],
  concatter_export: ["string", ["string"]]
});

lib.hs_init(0, ""); // actually pass stuff?

console.log(lib.concatter_export("works"));

lib.hs_exit();
