'use strict';

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

require('custom-event-polyfill');

module.exports.before = function (el, html) {
  el.insertAdjacentHTML('beforebegin', html);
};

module.exports.removeElement = function (el) {
  if (el && el.parentNode) {
    el.parentNode.removeChild(el);
  }
};

module.exports.offset = function (el) {
  var rect = el.getBoundingClientRect();
  return {
    top: rect.top + document.body.scrollTop,
    left: rect.left + document.body.scrollLeft
  };
};

module.exports.parseHTML = function (string) {
  var tmp = document.implementation.createHTMLDocument('');
  tmp.body.innerHTML = string;
  return tmp.body.children[0];
};

module.exports.hasClass = function (el, className) {
  if (el.classList) {
    return el.classList.contains(className);
  } else {
    return new RegExp('(^| )' + className + '( |$)', 'gi').test(el.className);
  }
};

module.exports.replaceSelectionWithHtml = function (html) {
  var range = void 0;
  if (window.getSelection && window.getSelection().getRangeAt) {
    range = window.getSelection().getRangeAt(0);
    range.deleteContents();
    var div = document.createElement("div");
    div.innerHTML = html;
    var frag = document.createDocumentFragment(),
        child = void 0;
    while (child = div.firstChild) {
      frag.appendChild(child);
    }
    range.insertNode(frag);
  } else if (document.selection && document.selection.createRange) {
    range = document.selection.createRange();
    range.pasteHTML(html);
  }
};

function deepExtend(out) {

  out = out || {};

  for (var i = 1; i < arguments.length; i++) {
    var obj = arguments[i];
    if (!obj) {
      continue;
    }

    for (var key in obj) {
      if (obj.hasOwnProperty(key)) {
        if (_typeof(obj[key]) === 'object') out[key] = deepExtend(out[key], obj[key]);else out[key] = obj[key];
      }
    }
  }

  return out;
};

module.exports.extend = deepExtend;

module.exports.triggerEvent = function (el, eventName, options) {
  var event = void 0;
  if (window.CustomEvent) {
    event = new CustomEvent(eventName, { cancelable: true });
  } else {
    event = document.createEvent('CustomEvent');
    event.initCustomEvent(eventName, false, false, options);
  }
  el.dispatchEvent(event);
};

module.exports.removeIndentNewline = function (str) {
  return str.replace(/(\n|\t)/g, '');
};