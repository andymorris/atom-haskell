var app = require('app');  // Module to control application life.
var BrowserWindow = require('browser-window');  // Module to create
// native browser window.

// Report crashes to our server.
require('crash-reporter').start();

// Keep a global reference of the window object, if you don't, the
// window will
// be closed automatically when the javascript object is GCed.
var mainWindow = null;




var ref = require("ref");
var ffi = require("ffi");

var stringPtr = ref.refType(ref.types.CString);
var lib = ffi.Library(__dirname + "/libHShaskell-ffi-0.1.0.0-ghc7.8.3", {
  hs_init: ["void", ["int", "string"]],
  hs_exit: ["void", []],
  concatter_export: ["string", ["string"]]
});
lib.hs_init(0, ""); // actually pass stuff?

console.log(lib.concatter_export("works"));





// Quit when all windows are closed.
app.on('window-all-closed', function() {
  if (process.platform != 'darwin')
    app.quit();
});

// Exit the haskell runtime before quitting
app.on("will-quit", function(e) {
  lib.hs_exit();
});

// This method will be called when atom-shell has done everything
// initialization and ready for creating browser windows.
app.on('ready', function() {
  // Create the browser window.
  mainWindow = new BrowserWindow({width: 800, height: 600});

  // and load the index.html of the app.
  mainWindow.loadUrl('file://' + __dirname + '/index.html');

  // Emitted when the window is closed.
  mainWindow.on('closed', function() {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the
    // time
    // when you should delete the corresponding element.
    mainWindow = null;
  });
});
