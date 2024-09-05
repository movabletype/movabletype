require('custom-event-polyfill');

module.exports.before = (el, html) => {
  el.insertAdjacentHTML('beforebegin', html);
}

module.exports.removeElement = (el) => {
  if(el && el.parentNode) {
    el.parentNode.removeChild(el);
  }
}

module.exports.offset = (el) => {
  const rect = el.getBoundingClientRect();
  return {
    top: rect.top + document.body.scrollTop,
    left: rect.left + document.body.scrollLeft
  }
}

module.exports.parseHTML = (string) => {
  const tmp = document.implementation.createHTMLDocument('');
  tmp.body.innerHTML = string;
  return tmp.body.children[0];
}

module.exports.hasClass = (el, className) => {
  if (el.classList) {
    return el.classList.contains(className);
  } else {
    return new RegExp('(^| )' + className + '( |$)', 'gi').test(el.className);
  }
}

module.exports.replaceSelectionWithHtml = (html) => {
  let range;
  if (window.getSelection && window.getSelection().getRangeAt) {
    range = window.getSelection().getRangeAt(0);
    range.deleteContents();
    const div = document.createElement("div");
    div.innerHTML = html;
    let frag = document.createDocumentFragment(), child;
    while ((child = div.firstChild)) {
      frag.appendChild(child);
    }
    range.insertNode(frag);
  } else if (document.selection && document.selection.createRange) {
    range = document.selection.createRange();
    range.pasteHTML(html);
  }
}

function deepExtend(out){

  out = out || {};

  for (var i = 1; i < arguments.length; i++) {
    var obj = arguments[i];
    if (!obj) {
      continue;
    }

    for (var key in obj) {
      if (obj.hasOwnProperty(key)) {
        if (typeof obj[key] === 'object')
          out[key] = deepExtend(out[key], obj[key]);
        else
          out[key] = obj[key];
      }
    }
  }

  return out;
};

module.exports.extend = deepExtend;

module.exports.triggerEvent = (el, eventName, options) => {
  let event;
  if (window.CustomEvent) {
    event = new CustomEvent(eventName, {cancelable:true});
  } else {
    event = document.createEvent('CustomEvent');
    event.initCustomEvent(eventName, false, false, options);
  }
  el.dispatchEvent(event);
}

module.exports.removeIndentNewline = (str) => {
  return str.replace(/(\n|\t)/g, '');
}
