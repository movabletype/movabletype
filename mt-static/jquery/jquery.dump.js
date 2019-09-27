//     jquery.dump.js

//     (c) 2012 Torkild Dyvik Olsen
//     This program may be freely distributed under the MIT license.

// A simple debug function to dump information about an object. Returns a
// string of a nested tree of the object dumped.
(function($) {

// Returns the dump of the current jQuery object (`this`).
$.fn.dump = function() {
   return $.dump(this);
}

// Dumps any object passed as the only parameter.
$.dump = function(object) {
   // The recursion function, used to determine each object and it's children
   // in the passed tree.
   var recursion = function(obj, level) {
      if(!level) level = 0;
      var dump = '', p = '';
      for(i = 0; i < level; i++) p += "\t";

      var t = type(obj);
      switch(t) {
         case "string":
            return '"' + obj + '"';
            break;
         case "number":
            return obj.toString();
            break;
         case "boolean":
            return obj ? 'true' : 'false';
         case "date":
            return "Date: " + obj.toLocaleString();
         case "array":
            dump += 'Array ( \n';
            $.each(obj, function(k,v) {
               dump += p + '\t' + k + ' => ' + recursion(v, level + 1) + '\n';
            });
            dump += p + ')';
            break;
         case "object":
            dump += 'Object { \n';
            $.each(obj, function(k,v) {
               dump += p + '\t' + k + ': ' + recursion(v, level + 1) + '\n';
            });
            dump += p + '}';
            break;
         case "jquery":
            dump += 'jQuery Object { \n';
            $.each(obj, function(k,v) {
               dump += p + '\t' + k + ' = ' + recursion(v, level + 1) + '\n';
            });
            dump += p + '}';
            break;
         case "regexp":
            return "RegExp: " + obj.toString();
         case "error":
            return obj.toString();
         case "document":
         case "domelement":
            dump += 'DOMElement [ \n'
                  + p + '\tnodeName: ' + obj.nodeName + '\n'
                  + p + '\tnodeValue: ' + obj.nodeValue + '\n'
                  + p + '\tinnerHTML: [ \n';
            $.each(obj.childNodes, function(k,v) {
               if(k < 1) var r = 0;
               if(type(v) == "string") {
                  if(v.textContent.match(/[^\s]/)) {
                     dump += p + '\t\t' + (k - (r||0)) + ' = String: ' + trim(v.textContent) + '\n';
                  } else {
                     r--;
                  }
               } else {
                  dump += p + '\t\t' + (k - (r||0)) + ' = ' + recursion(v, level + 2) + '\n';
               }
            });
            dump += p + '\t]\n'
                  + p + ']';
            break;
         case "function":
            var match = obj.toString().match(/^(.*)\(([^\)]*)\)/im);
            match[1] = trim(match[1].replace(new RegExp("[\\s]+", "g"), " "));
            match[2] = trim(match[2].replace(new RegExp("[\\s]+", "g"), " "));
            return match[1] + "(" + match[2] + ")";
         case "window":
         default:
            dump += 'N/A: ' + t;
            break;
      }

      return dump;
   }

   // Returns the type of the object passed as the only parameter.
   var type = function(obj) {
      var type = typeof(obj);

      if(type != "object") {
         return type;
      }

      switch(obj) {
         case null:
            return 'null';
         case window:
            return 'window';
         case document:
            return 'document';
         case window.event:
            return 'event';
         default:
            break;
      }

      if(obj.jquery) {
         return 'jquery';
      }

      switch(obj.constructor) {
         case Array:
            return 'array';
         case Boolean:
            return 'boolean';
         case Date:
            return 'date';
         case Object:
            return 'object';
         case RegExp:
            return 'regexp';
         case ReferenceError:
         case Error:
            return 'error';
         case null:
         default:
            break;
      }

      switch(obj.nodeType) {
         case 1:
            return 'domelement';
         case 3:
            return 'string';
         case null:
         default:
            break;
      }

      return 'Unknown';
   }

   // Start and return the recursion on the object
   return recursion(object);
}

// Trim strings
function trim(str) { return ltrim(rtrim(str)); }
function ltrim(str) { return str.replace(new RegExp("^[\\s]+", "g"), ""); }
function rtrim(str) { return str.replace(new RegExp("[\\s]+$", "g"), ""); }

})(jQuery);
