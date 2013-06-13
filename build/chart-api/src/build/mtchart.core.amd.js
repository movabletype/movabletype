(function (root, factory) {
  if (typeof exports === 'object') {
    var jquery = require('jquery');

    module.exports = factory(jquery);
  } else if (typeof define === 'function' && define.amd) {
    define(['jquery'], factory);
  }
}(this, function ($) {

  // @include mtchart.core.js

  return MT.ChartAPI;
}));
