function d(n){if(n.attr("srcdoc"))return!0;var r=n.attr("src");if(!r)return!0;var t=document.createElement("a");return t.href=r,t.hostname===window.location.hostname&&t.protocol===window.location.protocol&&t.port===window.location.port}tinymce.PluginManager.add("mt_protect",function(n){n.on("PreInit",function(){n.parser.addNodeFilter("noscript",function(t){t.forEach(function(o){o.remove()})});var r=n.parser.getNodeFilters().find(function(t){return t.name==="iframe"});r&&r.callbacks.unshift(function(t){t.forEach(function(o){var e=o.attr("sandbox"),l=o.replace;o.replace=function(c){var i=c.children();if(i[0]&&i[0].name==="iframe"){var a=i[0];if(!d(a))a.attr("sandbox",e);else{let s="allow-scripts";e===void 0?a.attr("data-mt-protect-no-sandbox","1"):(a.attr("data-mt-protect-sandbox",e),s=e.split(/\s+/).filter(function(f){return!/allow-same-origin/i.test(f)}).join(" ")),a.attr("sandbox",s)}}return l.apply(this,[c]),this}})})})});
