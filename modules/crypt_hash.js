// Generated by CoffeeScript 1.3.3
(function() {
  var crypto;

  crypto = require("crypto");

  module.exports.md5 = function(data) {
    return crypto.createHash('md5').update(data).digest("hex");
  };

}).call(this);
